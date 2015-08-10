module GitCompound
  module Command
    # Abstract Procedure class
    #
    class Procedure
      def initialize(_args)
      end

      def execute
        raise NotImplementedError
      end
    end
  end
end
