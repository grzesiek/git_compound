module GitCompound
  module Command
    module Procedure
      # Abstract Procedure class
      #
      class Procedure
        def initialize(_opts)
        end

        # Method with additional messages etc.
        #
        def execute!
          execute
        end

        # Main procedure entry point
        #
        def execute
          self.class.steps.to_h.keys.each do |name|
            execute_step(name)
          end
        end

        def execute_step(name)
          step_proc = self.class.steps.to_h[name]
          instance_eval(&step_proc) if step_proc
        end

        class << self
          attr_reader :steps

          # Valid options available for this procedure
          # see Element::Option
          #
          def options
            {}
          end

          # Name of procedure
          #
          def to_s
            name.split('::').last.downcase
          end

          private

          def step(name, &block)
            raise GitCompoundError, 'No block given !' unless block

            @steps = {} unless @steps
            @steps.store(name, block)
          end
        end
      end
    end
  end
end
