module GitCompound
  module Command
    module Arguments
      module Type
        module Argument
          # Abstract argument type
          #
          class Argument < Type
            def used
              [value!].compact
            end

            private

            def value!
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
