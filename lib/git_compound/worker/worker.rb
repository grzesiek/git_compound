module GitCompound
  module Worker
    # Abstract worker
    #
    class Worker
      def visit_component(_component)
      end

      def visit_manifest(_manifest)
      end

      def visit_task(_task)
      end

      # Maybe ?
      # def result
      # end
    end
  end
end
