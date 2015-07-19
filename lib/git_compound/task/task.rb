require 'pathname'

module GitCompound
  module Task
    # Base abstract class for task
    #
    class Task
      attr_reader :name

      def initialize(name, manifest, &block)
        raise GitCompoundError,
              "Block not given for task `#{name}`" unless block

        @name       = name
        @manifest   = manifest
        @block      = block
      end

      def execute
        raise NotImplementedError
      end

      private

      def execute_on(directory, component)
        path = Pathname.new(directory).expand_path.to_s
        @block.call(path, component)
      end
    end
  end
end
