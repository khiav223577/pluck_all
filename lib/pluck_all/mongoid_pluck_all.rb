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
  end
end
