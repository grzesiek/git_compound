module GitCompound
  module Command
    module Procedure
      # Abstract Procedure class
      #
      class Procedure
        def initialize(args)
          @args = args
        end

        # Method will additional messages etc.
        #
        def execute!
          execute
        end

        # Main procedure entry point
        #
        def execute
          raise NotImplementedError
        end
      end
    end
  end
end
