module GitCompound
  # Compound Domain Specific Language
  #
  module Dsl
    # DSL for Manifest
    #
    class ManifestDsl
      def initialize(contents)
        @name       = ''
        @components = {}
        @tasks      = {}
        instance_eval(contents)
      rescue => e
        raise CompoundSyntaxError, e
      end

      def name(component_name)
        @name = component_name.to_sym
      end

      def component(name, &block)
        @components.store(name.to_sym, Component.new(name, &block))
      end

      def task(name, &block)
        @tasks.store(name.to_sym, Task.new(name, &block))
      end
    end
  end
end
