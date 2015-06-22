module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(path, component)
        @path      = path
        @component = component
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          path.nil? || path.empty?
      end
    end
  end
end
