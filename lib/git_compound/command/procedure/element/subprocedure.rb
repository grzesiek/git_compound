module GitCompound
  module Command
    module Procedure
      module Element
        # Subprocedure mixin
        #
        module Subprocedure
          def self.included(parent_class)
            parent_class.extend(ClassMethods)
          end

          def initialize(args)
            @subprocedures = {}

            self.class.subprocedures.to_h.each_pair do |name, procedure|
              @subprocedures.store(name, procedure.new(args))
            end

            super
          end

          def subprocedure(name)
            @subprocedures[name.to_sym].execute
          end

          # Class methods for extended class
          #
          module ClassMethods
            attr_reader :subprocedures

            def add_subprocedure(name, procedure)
              @subprocedures = {} unless @subprocedures
              @subprocedures.store(name.to_sym, procedure)
            end
          end
        end
      end
    end
  end
end
