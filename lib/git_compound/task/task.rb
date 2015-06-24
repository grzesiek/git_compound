module GitCompound
  module Task
    # Base abstract class for task
    #
    class Task
      def initialize(name, subject, &block)
        raise GitCompoundError,
              "Block not given for task `#{name}`" unless block

        @name    = name
        @subject = subject
        @block   = block
      end

      def execute
        raise NotImplementedError
      end

      private

      def execute_on(component)
        @block.call(component.destination_path, component)
      end
    end
  end
end
