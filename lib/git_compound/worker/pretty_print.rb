module GitCompound
  module Worker
    class PrettyPrint < AbstractWorker
      def initialize
        @components = []
      end

      def visit_component(component)
        @components << component.name
        puts component.name
      end

      def visit_manifest(manifest)
        nil
      end
    end
  end
end
