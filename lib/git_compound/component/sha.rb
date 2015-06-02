module GitCompound
  class Component
    class SHA < AbstractVersion
      def initialize(component, sha)
        @component = component
        @sha = sha
      end

      def reference
        @sha
      end

      def sha
        @sha
      end

      def reachable?
        raise NotImplementedError # TODO
      end
    end
  end
end
