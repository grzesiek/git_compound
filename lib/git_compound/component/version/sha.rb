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

        # If sha matches ref in remote repository then
        #   this ref should be returned
        # else return sha.
        #
        def ref
          ref = @repository.refs.find { |refs_a| refs_a.include?(@sha) }
          ref ? ref.last : @sha
        end

        # rubocop:disable Style/TrivialAccessors
        def sha
          @sha
        end
        # rubocop:enable Style/TrivialAccessors

        def reachable?
          # TODO, we assume that SHA is always available as we do not want
          # to clone repository and check if commit exists -- this probably
          # needs to be changed when someone finds better solution for this.
          true
        end

        def to_s
          "sha: #{@sha[0..7]}"
        end
      end
    end
  end
end
