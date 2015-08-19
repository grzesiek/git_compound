module GitCompound
  module Command
    module Arguments
      module Type
        module Argument
          # String argument implementation
          #
          class String < Argument
            def valid?
              value!.is_a?(::String)
            end

            private

            def value!
              @args.find { |arg| arg.is_a?(::String) }
            end

            def value
              value!.to_s
            end
          end
        end
      end
    end
  end
end
