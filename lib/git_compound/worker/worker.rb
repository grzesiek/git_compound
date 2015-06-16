module GitCompound
  module Worker
    # Abstract worker
    #
    class Worker
      include Singleton

      def visit_component(_component)
        raise NotImplementedError
      end

      def visit_manifest(_manifest)
        raise NotImplementedError
      end

      def visit_task(_task)
        raise NotImplementedError
      end

      # Maybe ?
      # def result
      #   raise NotImplementedError
      # end
    end
  end
end
