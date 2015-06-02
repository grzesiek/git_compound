module GitCompound
  class Component
    module Version
      # Component version indicated by SHA hash
      #
      class SHA < AbstractVersion
        def initialize(component, sha)
          @component = component
          @sha = sha
        end

        def reference
          @sha
        end

        def sha # rubocop:disable Style/TrivialAccessors
          @sha
        end

        def reachable?
          raise NotImplementedError # TODO
        end
      end
    end
  end
end
