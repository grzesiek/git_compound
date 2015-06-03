module GitCompound
  class Component
    module Version
      # Abstraction for component versions like
      #   gem version, sha and branch
      #
      class AbstractVersion
        def initialize
          raise NotImplementedError
        end

        # Should return git reference (ex branch, tag or sha)
        # This should not raise exception if unreachable
        #
        def ref
          raise NotImplementedError
        end

        # Should return sha for specified reference
        #   (ex tagged commit sha or head of specified branch)
        #
        def sha
          raise NotImplementedError
        end

        # Should return true if this reference in source repository
        #   is reachable
        #
        def reachable?
          raise NotImplementedError
        end
      end
    end
  end
end
