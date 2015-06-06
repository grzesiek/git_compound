module GitCompound
  module Worker
    # Worker that prints dependency tree
    #
    class PrettyPrint < AbstractWorker
      def initialize
        @indent = 0
      end

      def visit_component(component)
        @indent = 0 if root_component?(component)
        print_component(component)
      end

      def visit_manifest(manifest)
        @root_manifest ||= manifest
        @indent += 1
      end

      private

      def root_component?(component)
        root_components = @root_manifest.components.values
        root_components.include?(component)
      end

      def print_component(component)
        print_line("`#{component.name}` component, #{component.source.version}")
      end

      def print_line(text)
        puts indentation + text
      end

      def indentation
        '  ' * @indent
      end
    end
  end
end
