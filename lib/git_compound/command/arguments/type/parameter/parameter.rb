module GitCompound
  module Command
    module Arguments
      module Type
        module Parameter
          # Abstract parameter type
          #
          class Parameter < Type
            def used
              valid? ? [@key, value!].compact : []
            end

            private

            def value!
              @args[@args.index(@key) + 1]
            end
          end
        end
      end
    end
  end
end
