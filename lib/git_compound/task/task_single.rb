module GitCompound
  module Task
    # Single task for single component
    #
    class TaskSingle < Task
      def initialize(name, subject, &block)
        super
        @component = subject
      end

      def execute
        if @component
          execute_on(@component.destination_path, @component)
        else
          # Root manifest without parent
          execute_on(Dir.pwd, nil)
        end
      end
    end
  end
end
