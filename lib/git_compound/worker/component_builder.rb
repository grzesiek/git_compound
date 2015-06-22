module GitCompound
  module Worker
    # Worker that builds components
    #
    class ComponentBuilder < Worker
      def visit_component(component)
        # if component.destination.exists? component.build
      end
    end
  end
end
