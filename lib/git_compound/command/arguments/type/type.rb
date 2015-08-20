module GitCompound
  module Command
    module Arguments
      module Type
        # Abstract argument type
        #
        class Type
          def initialize(key, args)
            @key  = key
            @args = args
          end

          def parse
            valid? ? { @key => value } : {}
          end

          # Return true if arguments array contains
          # this parameter/argument, else - return false
          #
          def valid?
            raise NotImplementedError
          end

          # Returns array of arguments that has been used
          #
          def used
            raise NotImplementedError
          end

          private

          # Returns bare value extracted from args
          # or nil if bare arguments is irrelevant
          #
          def value!
            raise NotImplementedError
          end

          # Return value converted to valid type
          #
          def value
            raise NotImplementedError
          end
        end
      end
    end
  end
end
