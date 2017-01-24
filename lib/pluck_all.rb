require "pluck_all/version"
require 'active_record'

class ActiveRecord::Base
  if !defined?(attribute_types) && defined?(column_types)
    class << self
      #Rails 5 把column_types改成attribute_types
      alias_method :attribute_types, :column_types
    end
  end
end
module ActiveRecord
  [
    *([Type::Value, Type::Integer, Type::Serialized] if defined?(Type::Value)),
    *([Enum::EnumType] if defined?(Enum::EnumType)),
  ].each do |s|
    s.class_eval do
      if !method_defined?(:deserialize) && method_defined?(:type_cast_from_database)
        #Rails 5 把 type_cast_from_database 改成 deserialize
        alias deserialize type_cast_from_database
      end
    end
  end
end
class ActiveRecord::Relation
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.0')
    def pluck_all(*args)
      result = select_all(*args, *@pluck_all_extra_select)
      result.map! do |attributes| #This map! behaves different to array#map!
        initialized_attributes = klass.initialize_attributes(attributes)
        attributes.each do |key, attribute|
          attributes[key] = klass.type_cast_attribute(key, initialized_attributes) #TODO 現在AS過後的type cast會有一點問題
        end
        attributes.except!(*@pluck_all_extra_select) if @pluck_all_extra_select
        next attributes
      end
    end
  else
    def pluck_all(*args)
      result = select_all(*args, *@pluck_all_extra_select)
      attribute_types = klass.attribute_types
      result.map! do |attributes| #This map! behaves different to array#map!
        attributes.each do |key, attribute|
          attributes[key] = result.send(:column_type, key, attribute_types).deserialize(attribute) #TODO 現在AS過後的type cast會有一點問題，但似乎原生的pluck也有此問題
        end
        attributes.except!(*@pluck_all_extra_select) if @pluck_all_extra_select
        next attributes
      end
    end
  end
  def extra_select(*args)
    @pluck_all_extra_select = args.map(&:to_s)
    return self
  end
private
  def select_all(*args)
    args.map! do |column_name|
      if column_name.is_a?(Symbol) && column_names.include?(column_name.to_s)
        "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(column_name)}"
      else
        column_name.to_s
      end
    end
    relation = clone
    return klass.connection.select_all(relation.select(args).to_sql)
    #return klass.connection.select_all(relation.arel)
  end
#----------------------------------
#  Support casting CarrierWave url
#----------------------------------
  def cast_carrier_wave_uploader_url(key, value)
    if defined?(CarrierWave)
      key_sym = key.to_sym
      return value if !klass.uploaders.key?(key_sym)
      obj = klass.new
      obj[key_sym] = value
      return obj.send(:_mounter, key_sym).uploader.to_s
    else
      return value
    end
  end
end


class ActiveRecord::Relation
  if Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new('4.0.2')
    def pluck_array(*args)
      return pluck_all(*args).map{|hash|
        result = hash.values #P.S. 這裡是相信ruby 1.9以後，hash.values的順序跟insert的順序一樣。
        next (result.one? ? result.first : result)
      }
    end
  else
    alias_method :pluck_array, :pluck if not method_defined?(:pluck_array)
  end
end


class ActiveRecord::Base
  def self.pluck_all(*args)
    self.where('').pluck_all(*args)
  end
  def self.pluck_array(*args)
    self.where('').pluck_array(*args)
  end
end
