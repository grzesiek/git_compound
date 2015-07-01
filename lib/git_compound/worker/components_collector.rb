module GitCompound
  module Worker
    # Worker thas collects are encountered components
    #
    class ComponentsCollector < Worker
      attr_reader :components

      def initialize(collection)
        raise GitCompoundError, 'Collection should be a Hash' unless
          collection.is_a? Hash

          @components = collection
      end

      def visit_component(component)
        @components.store(component.name, component)
      end
    end
  end
end
