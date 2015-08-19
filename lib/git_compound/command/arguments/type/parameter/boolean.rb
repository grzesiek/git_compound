module GitCompound
  module Command
    module Arguments
      module Type
        module Parameter
          # Boolean parameter implmentation
          #
          class Boolean < Type
            def valid?
              @args.include?(@key)
            end

            private

            def value!
              nil
            end

            def value
              true
            end
          end
        end
      end
    end
  end
end
