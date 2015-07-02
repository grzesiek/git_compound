module GitCompound
  module Worker
    # Worker that prints dependency tree
    #
    class PrettyPrint < Worker
      def visit_component(component)
        print_component(component)
      end

      private

      def print_component(component)
        Logger.inline '  ' * component.ancestors.count
        Logger.info "`#{component.name}` component, #{component.source.version}"
      end
    end
  end
end
