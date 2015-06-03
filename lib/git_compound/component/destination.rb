module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(path)
        @path = path
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          path.nil? || path.empty?
      end
    end
  end
end
