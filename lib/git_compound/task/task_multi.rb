module GitCompound
  module Task
    # Task for each component
    #
    class TaskMulti < Task
      def execute
        @subject.each { |component| execute_on(component) }
      end
    end
  end
end
