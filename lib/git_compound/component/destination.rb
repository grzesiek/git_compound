module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(component, path)
        @component = component
        @path = path
      end
    end
  end
end
