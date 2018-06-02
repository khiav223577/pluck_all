# frozen_string_literal: true
module Mongoid
  module Findable
    delegate :pluck_all, :pluck_array, to: :with_default_scope
  end

  module Contextual
    delegate :pluck_all, :pluck_array, to: :context

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
          values = normalized_select.keys.map do |n|
            n =~ /\./ ? doc[n.partition('.')[0]] : doc[n]
          end
          plucked << (values.size == 1 ? values.first : values)
        end
      end

      def pluck_all(*fields)
        normalized_select = get_normalized_select(fields)
        get_query_data(normalized_select).reduce([]) do |plucked, doc|
          values = normalized_select.keys.map do |n|
            [n, n =~ /\./ ? doc[n.partition('.')[0]] : doc[n]]
          end
          plucked << values.to_h
        end
      end

      private

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
