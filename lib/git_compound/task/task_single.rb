module GitCompound
  module Task
    # Single task for single component
    #
    class TaskSingle < Task
      def initialize(name, subject, &block)
        super
        @manifest  = subject
        @component = @manifest.parent
      end

      def execute
        if @component
          execute_on(@component.destination_path, @component.manifest)
        else
          # Root manifest without parent
          execute_on(Dir.pwd, @manifest)
        end
      end
    end
  end
end
