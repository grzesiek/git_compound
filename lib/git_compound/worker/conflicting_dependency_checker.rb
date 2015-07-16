module GitCompound
  module Worker
    # Worker that detects conflicting dependencies
    #
    class ConflictingDependencyChecker < Worker
      def initialize
        @components = []
      end

      def visit_component(component)
        if conflict_exists?(component)
          raise ConflictingDependencyError,
                "Conflicting dependency detected in component `#{component.name}`!"
        end
        @components << component
      end

      private

      def conflict_exists?(component)
        @components.any? do |other|
          !(component == other && component.version == other.version) &&
            component.path == other.path
        end
      end
    end
  end
end
