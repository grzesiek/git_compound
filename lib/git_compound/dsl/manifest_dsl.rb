module GitCompound
  # Compound Domain Specific Language
  #
  module DSL
    # DSL for Manifest
    #
    class ManifestDSL
      def initialize(manifest, contents)
        @manifest            = manifest
        @manifest.name       = ''
        @manifest.components = {}
        @manifest.tasks      = {}
        instance_eval(contents)
      end

      def name(component_name)
        @manifest.name = component_name.to_sym
      end

      def component(name, &block)
        @manifest.components.store(name.to_sym, Component.new(name, @manifest, &block))
      end

      def task(name, type = nil, &block)
        new_task = Task.factory(name, type, @manifest, &block)
        @manifest.tasks.store(name.to_sym, new_task) if new_task
      end
    end
  end
end
