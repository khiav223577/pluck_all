module Mongoid
  module Findable
    delegate :pluck_all, to: :with_default_scope
  end

  module Contextual

    delegate(:pluck_all, to: :context)

    class Memory
      def pluck_all(*fields)
        pluck(fields)
      end
    end

    class None
      def pluck_all(*)
        []
      end
    end

    class Mongo
      def pluck_all(*fields)
        normalized_select = fields.inject({}) do |hash, f|
          hash[klass.database_field_name(f)] = 1
          hash
        end

        view.projection(normalized_select).reduce([]) do |plucked, doc|
          values = normalized_select.keys.map do |n|
            [n, n =~ /\./ ? doc[n.partition('.')[0]] : doc[n]]
          end.to_h
          plucked << values
        end
      end
    end
  end
end
