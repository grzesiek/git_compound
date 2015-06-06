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

        def to_s
          "sha: #{@sha[0..8]}"
        end
      end
    end
  end
end
