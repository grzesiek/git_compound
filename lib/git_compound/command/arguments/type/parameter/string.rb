module GitCompound
  module Command
    module Arguments
      module Type
        module Parameter
          # String parameter implementation
          #
          class String < Type
            def valid?
              @args.include?(@key) && value!.is_a?(::String)
            end

            private

            def value
              value!.to_s
            end
          end
        end
      end
    end
  end
end
