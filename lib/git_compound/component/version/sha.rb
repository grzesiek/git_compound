module GitCompound
  class Component
    module Version
      # Component version indicated by SHA hash
      #
      class SHA < AbstractVersion
        def initialize(repository, sha)
          @repository = repository
          @sha = sha
        end

        def ref
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
