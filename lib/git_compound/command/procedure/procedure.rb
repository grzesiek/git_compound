module GitCompound
  module Command
    module Procedure
      # Abstract Procedure class
      #
      class Procedure
        def initialize(args)
          @args = args
        end

        def execute
          raise NotImplementedError
        end
      end
    end
  end
end
