module ActiveRecord
  [
    *([Type::Value, Type::Integer, Type::Serialized] if defined?(Type::Value)),
    *([Enum::EnumType] if defined?(Enum::EnumType)),
  ].each do |s|
    s.class_eval do
      if !method_defined?(:deserialize) && method_defined?(:type_cast_from_database)
        # deserialize was changed to type_cast_from_database in Rails 5
        alias_method :deserialize, :type_cast_from_database
      end
    end
  end
end
