module GitCompound
  module Task
    # Single task for single component
    #
    class TaskSingle < Task
      def execute
        execute_on(@subject)
      end
    end
  end
end
