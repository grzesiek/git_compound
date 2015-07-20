module GitCompound
  module Worker
    # Worker that executes manifest tasks
    # This happens when visitor visits manifests in reverse order
    #
    class TaskRunner < Worker
      def visit_task(task)
        Logger.info "Running: `#{task.name}` task"
        task.execute
      end
    end
  end
end
