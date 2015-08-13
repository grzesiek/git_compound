module GitCompound
  module Command
    module Procedure
      module Element
        # Parameter mixin
        #
        module Parameter
          def initialize(opts)
            @opts = opts
            super
          end

          def self.included(parent_class)
            parent_class.extend(ClassMethods)
          end

          private

          # Class methods
          #
          module ClassMethods
            def add_parameter(name, metadata)
              @parameters = {} unless @parameters

              raise GitCompoundError, 'You need to specify type of argument !' unless
                metadata.include?(:type)

              @parameters.store(name, metadata)
            end

            def options
              (@parameters || {}).merge(super)
            end
          end

          class Boolean; end
        end
      end
    end
  end
end
