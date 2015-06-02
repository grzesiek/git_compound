class GitCompound
  class Component
    class Branch < AbstractVersion
      def initialize(component, branch)
        @component = component
        @branch = branch
      end

      def reference!
        @branch
      end

      def sha
        raise DependencyError,
              "Branch #{@branch} not available in #{@source.location} " \
              "for component `#{@component.name}`" unless reachable?
        @component.source.repository.branches[@branch]
      end

      def reachable?
        @component.source.repository.ref_exists?(@branch)
      end
    end
  end
end
