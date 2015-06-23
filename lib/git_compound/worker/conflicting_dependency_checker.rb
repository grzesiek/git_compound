module GitCompound
  module Worker
    # Worker that detects conflicting dependencies
    #
    class ConflictingDependencyChecker < Worker
      def initialize
        @components = []
      end

      def visit_component(component)
        if component.conflicts?(*@components)
          raise ConflictingDependencyError,
                "Conflicting dependency detected in component `#{component.name}`!"
        end
        @components << component
      end
    end
  end
end
