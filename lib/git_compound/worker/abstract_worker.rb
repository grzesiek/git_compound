module GitCompound
  module Worker
    class AbstractWorker
      include Singleton

      def visit_component(component)
        raise NotImplementedError
      end

      def visit_manifest(manifest)
        raise NotImplementedError
      end

      def visit_task(task)
        raise NotImplementedError
      end

      def result
        raise NotImplementedError
      end
    end
  end
end
