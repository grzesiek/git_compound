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
        @components.any? { |other_component| conflicting?(component, other_component) }
      end

      def conflicting?(component1, component2)
        match_destination =
          (component1.destination.path == component2.destination.path)
        match_identity_and_version =
          (component1 == component2 && component1.version == component2.version)

        match_destination && !match_identity_and_version
      end
    end
  end
end
