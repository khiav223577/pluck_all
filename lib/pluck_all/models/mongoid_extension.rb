# frozen_string_literal: true
module Mongoid
  module Document::ClassMethods
    def pluck_array(*fields)
      where(nil).pluck_array(*fields)
    end

    def pluck_all(*fields)
      where(nil).pluck_all(*fields)
    end
  end

  module Findable
    if singleton_class < Forwardable
      def_delegators :with_default_scope, :pluck_all, :pluck_array
    else
      delegate :pluck_all, :pluck_array, to: :with_default_scope
    end
  end

  module Contextual
    if singleton_class < Forwardable
      def_delegators :context, :pluck_all, :pluck_array
    else
      delegate :pluck_all, :pluck_array, to: :context
    end

    class None
      def pluck_array(*)
        []
      end

      def pluck_all(*)
        []
      end
    end

    class Mongo
      def pluck_array(*fields)
        normalized_select = get_normalized_select(fields)
        get_query_data(normalized_select).reduce([]) do |plucked, doc|
          values = normalized_select.keys.map(&plucked_value_mapper(:array, doc))
          plucked << (values.size == 1 ? values.first : values)
        end
      end

      def pluck_all(*fields)
        normalized_select = get_normalized_select(fields)
        get_query_data(normalized_select).reduce([]) do |plucked, doc|
          values = normalized_select.keys.map(&plucked_value_mapper(:all, doc))
          plucked << values.to_h
        end
      end

      private

      def plucked_value_mapper(type, doc)
        proc do |n|
          values = [n, n =~ /\./ ? doc[n.partition('.')[0]] : doc[n]]
          case type
          when :array then values[1]
          when :all   then values
          end
        end
      end

      def get_query_data(normalized_select)
        return (@view ? @view.projection(normalized_select) : query.dup.select(normalized_select))
      end

      def get_normalized_select(fields)
        fields.each_with_object({}) do |f, hash|
          hash[klass.database_field_name(f)] = 1
        end
      end
    end
  end
end
