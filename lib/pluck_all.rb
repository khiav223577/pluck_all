require "pluck_all/version"
require 'rails'
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
  if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('4.0.0')
    def pluck_all(*args)
      result = select_all(*args)
      result.map! do |attributes|
        initialized_attributes = klass.initialize_attributes(attributes)
        attributes.each do |key, attribute|
          attributes[key] = klass.type_cast_attribute(key, initialized_attributes) #TODO 現在AS過後的type cast會有一點問題
        end
      end
    end
  else
    def pluck_all(*args)
      result = select_all(*args)
      attribute_types = klass.attribute_types
      result.map! do |attributes| #這邊的map似乎跟array.map!不一樣，result的值不會變
        attributes.each do |key, attribute|
          attributes[key] = result.send(:column_type, key, attribute_types).deserialize(attribute) #TODO 現在AS過後的type cast會有一點問題，但似乎原生的pluck也有此問題
        end
      end
    end
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
    relation.select_values = args
    return klass.connection.select_all(relation.to_sql)
    #return klass.connection.select_all(relation.arel)
  end
end

if Gem::Version.new(Rails::VERSION::STRING) < Gem::Version.new('4.0.2')
  class ActiveRecord::Relation
    def pluck_array(*args)
      return pluck_all(*args).map{|hash|
        result = hash.values #P.S. 這裡是相信ruby 1.9以後，hash.values的順序跟insert的順序一樣。
        next (result.one? ? result.first : result)
      }
    end
  end
else
  alias_method :pluck_array, :pluck if not method_defined?(:pluck_array)
end


class ActiveRecord::Base
  def self.pluck_all(*args)
    self.where('').pluck_all(*args)
  end
  def self.pluck_array(*args)
    self.where('').pluck_array(*args)
  end
end
