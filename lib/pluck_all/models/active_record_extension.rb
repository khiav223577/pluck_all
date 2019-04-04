require_relative 'patches/attribute_types'
require_relative 'patches/deserialize'

class ActiveRecord::Relation
  def cast_need_columns(column_names, _klass = nil)
    @pluck_all_cast_need_columns = column_names.map(&:to_s)
    @pluck_all_cast_klass = _klass
    return self
  end

  def select_all(*column_names)
    relation = clone
    return klass.connection.select_all(relation.select(column_names).to_sql)
  end

  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.0')
    def pluck_all(*column_names, cast_uploader_url: true)
      column_names.map!(&to_sql_column_name)
      result = select_all(*column_names)
      result.map! do |attributes| # This map! behaves different to array#map!
        initialized_attributes = klass.initialize_attributes(attributes)
        attributes.each do |key, _attribute|
          attributes[key] = klass.type_cast_attribute(key, initialized_attributes) # TODO: 現在AS過後的type cast會有一點問題
        end
        cast_carrier_wave_uploader_url(attributes) if cast_uploader_url
        next attributes
      end
    end

    private

    def to_sql_column_name
      proc do |column_name|
        if column_name.is_a?(Arel::Attributes::Attribute)
          "#{column_name.relation.name}.#{column_name.name}"
        elsif column_name.is_a?(Symbol) && column_names.include?(column_name.to_s)
          "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(column_name)}"
        else
          column_name.to_s
        end
      end
    end
  else
    def pluck_all(*column_names, cast_uploader_url: true)
      column_names.map!(&to_sql_column_name)
      if has_include?(column_names.first)
        relation = apply_join_dependency
        return relation.pluck_all(*column_names)
      end
      result = select_all(*column_names)
      attribute_types = klass.attribute_types
      result.map! do |attributes| # This map! behaves different to array#map!
        attributes.each do |key, attribute|
          attributes[key] = result.send(:column_type, key, attribute_types).deserialize(attribute) # TODO: 現在AS過後的type cast會有一點問題，但似乎原生的pluck也有此問題
        end
        cast_carrier_wave_uploader_url(attributes) if cast_uploader_url
        next attributes
      end
    end

    private

    def to_sql_column_name
      proc do |column_name|
        if column_name.is_a?(Arel::Attributes::Attribute)
          "#{column_name.relation.name}.#{column_name.name}"
        elsif column_name.is_a?(Symbol) && attribute_alias?(column_name)
          attribute_alias(column_name)
        else
          column_name.to_s
        end
      end
    end
  end

  # ----------------------------------------------------------------
  # ● Support casting CarrierWave url
  # ----------------------------------------------------------------
  def cast_carrier_wave_uploader_url(attributes)
    if defined?(CarrierWave) && klass.respond_to?(:uploaders)
      @pluck_all_cast_klass ||= klass
      @pluck_all_uploaders ||= @pluck_all_cast_klass.uploaders.select{|key, _uploader| attributes.key?(key.to_s) }
      @pluck_all_uploaders.each do |key, _uploader|
        {}.tap do |hash|
          @pluck_all_cast_need_columns.each{|k| hash[k] = attributes[k] } if @pluck_all_cast_need_columns
          obj = @pluck_all_cast_klass.new(hash)
          obj[key] = attributes[key_s = key.to_s]
          # https://github.com/carrierwaveuploader/carrierwave/blob/87c37b706c560de6d01816f9ebaa15ce1c51ed58/lib/carrierwave/mount.rb#L142
          attributes[key_s] = obj.send(key)
        end
      end
    end
    return attributes
  end
end

class ActiveRecord::Relation
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.2')
    def pluck_array(*args)
      return pluck_all(*args, cast_uploader_url: false).map do |hash|
        result = hash.values # P.S. 這裡是相信ruby 1.9以後，hash.values的順序跟insert的順序一樣。
        next (args.one? ? result.first : result)
      end
    end
  else
    alias pluck_array pluck if not method_defined?(:pluck_array)
  end
end

class << ActiveRecord::Base
  def cast_need_columns(*args)
    where(nil).cast_need_columns(*args)
  end

  def pluck_all(*args)
    where(nil).pluck_all(*args)
  end

  def pluck_array(*args)
    where(nil).pluck_array(*args)
  end
end

module ActiveRecord::NullRelation
  def pluck_all(*_args)
    []
  end
end
