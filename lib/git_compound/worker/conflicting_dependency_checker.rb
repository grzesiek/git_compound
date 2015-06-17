module GitCompound
  module Worker
    # Worker that detects conflicting dependencies
    #
    class ConflictingDependencyChecker < Worker
      def visit_component(component)
        return unless conflict_exists?(component)
        raise ConflictingDependencyError,
              "Conflicting dependency detected in component `#{component.name}`!"
      end

      def visit_manifest(_manifest)
      end

      private

      def conflict_exists?(component)
      end
    end
  end
end
