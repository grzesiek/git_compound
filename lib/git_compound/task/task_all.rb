module GitCompound
  module Task
    # Task for all descendant components in manifest
    #
    class TaskAll < Task
      def initialize(name, manifest, &block)
        super
        @components = components_collect!
      end

      def execute
        @components.each_value do |component|
          execute_on(component.destination_path, component)
        end
      end

      private

      def components_collect!
        components = {}
        @manifest.process(Worker::CircularDependencyChecker.new,
                          Worker::ComponentsCollector.new(components))
        components
      end
    end
  end
end
