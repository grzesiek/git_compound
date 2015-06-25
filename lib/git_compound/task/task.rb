module GitCompound
  module Task
    # Base abstract class for task
    #
    class Task
      attr_reader :name

      def initialize(name, subject, &block)
        raise GitCompoundError,
              "Block not given for task `#{name}`" unless block

        @name      = name
        @subject   = subject
        @block     = block
      end

      def execute
        raise NotImplementedError
      end

      private

      def execute_on(directory, component)
        @block.call(directory, component)
      end
    end
  end
end
