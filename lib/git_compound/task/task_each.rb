module GitCompound
  module Task
    # Task for each component defined in manifest
    #
    class TaskEach < Task
      def initialize(name, manifest, &block)
        super
        @components = manifest.components
      end

      def execute
        @components.each_value do |component|
          execute_on(component.destination_path, component)
        end
      end
    end
  end
end
