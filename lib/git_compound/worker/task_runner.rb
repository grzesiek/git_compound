module GitCompound
  module Worker
    # Worker that prints dependency tree
    #
    class TaskRunner < Worker
      def visit_task(task)
        task.execute
      end
    end
  end
end
