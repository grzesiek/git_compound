module GitCompound
  module Command
    module Procedure
      module Element
        # Option mixin
        #
        module Option
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
              add_option(name, :parameter, metadata)
            end

            def add_argument(name, metadata)
              add_option(name, :argument, metadata)
            end

            def options
              (@options || {}).merge(super)
            end

            private

            def add_option(name, variant, metadata)
              @options = {} unless @options

              raise GitCompoundError, 'You need to specify type of an option !' unless
                metadata.include?(:type)

              @options.store(name, metadata.merge(variant: variant))
            end
          end
        end
      end
    end
  end
end
