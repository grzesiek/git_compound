module GitCompound
  module Worker
    # Worker that checks if unwanted circular dependency exists
    #
    class CircularDependencyChecker < Worker
      def visit_component(component)
        @element = component
        raise_error if circular_dependency_exists?
      end

      def visit_manifest(manifest)
        @element = manifest
        raise_error if circular_dependency_exists?
      end

      private

      def circular_dependency_exists?
        @element.ancestors.include?(@element)
      end

      def raise_error
        name = @element.name
        type = @element.class.name.downcase

        raise CircularDependencyError,
              "Circular dependency detected in #{type} `#{name}`!"
      end
    end
  end
end
