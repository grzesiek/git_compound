module GitCompound
  class Component
    module Version
      # Component version indicated by branch (head of branch)
      #
      class Branch < VersionStrategy
        def initialize(repository, branch)
          @repository = repository
          @branch = branch
        end

        def ref
          @branch
        end

        def sha
          @repository.branches[@branch]
        end

        def reachable?
          @repository.ref_exists?(@branch)
        end

        def to_s
          "branch: #{@branch}"
        end
      end
    end
  end
end
