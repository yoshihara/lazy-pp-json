module Lazy
  module PP
    class JSON < String
      def new(raw)
        @raw = raw
      end
    end
  end
end
