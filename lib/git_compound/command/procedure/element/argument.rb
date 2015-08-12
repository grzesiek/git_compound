module GitCompound
  module Command
    module Procedure
      module Element
        # Argument mixin
        #
        module Argument
          def initialize(args)
            super
          end

          def included(parent)
            parent.extend(ClassMethods)
          end

          # Class methods
          #
          module ClassMethods
            def add_argument(_name, _description)
            end
          end
        end
      end
    end
  end
end
