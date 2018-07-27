class ActiveRecord::Base
  if !defined?(attribute_types) && defined?(column_types)
    class << self
      # column_types was changed to attribute_types in Rails 5
      alias_method :attribute_types, :column_types
    end
  end
end
