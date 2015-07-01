module GitCompound
  module Task
    # Task for all descendant components in manifest
    #
    class TaskAll < Task
      def initialize(name, subject, &block)
        super
        @manifest   = subject
        @components = components_collect!
      end

      def execute
        @components.each_value do |component|
          execute_on(component.destination_path, component)
        end
      end

      private

      def components_collect!
      end
    end
  end
end
