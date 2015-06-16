module GitCompound
  module Worker
    # Worker that prints dependency tree
    #
    class CircularDependencyChecker < Worker
      def visit_component(component)
        return unless circular_dependency_exists?(component)
        raise CircularDependencyError,
              "Circular dependency detected in component `#{component.name}`!"
      end

      def visit_manifest(_manifest)
      end

      private

      def circular_dependency_exists?(component)
        component.ancestors.include?(component)
      end
    end
  end
end
