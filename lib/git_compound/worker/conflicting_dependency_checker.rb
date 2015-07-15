module GitCompound
  module Worker
    # Worker that detects conflicting dependencies
    #
    class ConflictingDependencyChecker < Worker
      # TODO: this should collect all components first
      #       using ComponentsCollector worker
      #
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
          component.destination_path == other.destination_path &&
            !(component == other && component.version == other.version)
        end
      end
    end
  end
end
