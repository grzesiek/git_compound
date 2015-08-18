module GitCompound
  module Command
    module Arguments
      module Type
        # Abstract argument type
        #
        class Type
          def initialize(arguments, expected, pointer)
            @arguments = arguments
            @expected  = expected
            @pointer   = pointer
          end

          def matches?
          end

          def parse
          end
        end
      end
    end
  end
end
