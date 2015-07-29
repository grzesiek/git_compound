module GitCompound
  class Component
    module Version
      # Component version indicated by SHA hash
      #
      class SHA < VersionStrategy
        def initialize(repository, sha)
          @repository = repository
          @sha = sha
        end

        # If @sha matches ref in remote repository then
        #   this ref should be returned
        # else return @sha.
        #
        def ref
          ref = @repository.refs.find { |refs_a| refs_a.include?(@sha) }
          ref ? ref.last : @sha
        end

        def sha # rubocop:disable Style/TrivialAccessors
          @sha
        end

        def reachable?
          # We assume that SHA is always available as we do not want
          # to clone repository and check it -- this probably needs
          # to be changed, so -- TODO
          true
        end

        def to_s
          "sha: #{@sha[0..7]}"
        end
      end
    end
  end
end
