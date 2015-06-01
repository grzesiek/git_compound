module GitCompound
  class Component
    # Component source
    #
    class Source
      attr_reader :location, :repository

      def initialize(component, source)
        @location   = source
        @component  = component
        @repository = Repository.factory(@location)
      end
    end
  end
end
