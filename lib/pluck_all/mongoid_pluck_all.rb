module Mongoid
  module Findable
    delegate :pluck_all, to: :with_default_scope
  end

  module Contextual
    class Memory
      def pluck_all(*fields)
        pluck(fields)
      end
    end
  end
end
