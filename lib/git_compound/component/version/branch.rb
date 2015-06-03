module GitCompound
  class Component
    module Version
      # Component version indicated by branch (head of branch)
      #
      class Branch < AbstractVersion
        def initialize(repository, branch)
          @repository = repository
          @branch = branch
        end

        def reference
          @branch
        end

        def sha
          # TODO
          # raise DependencyError,
          #       "Branch #{@branch} not available in #{@source.location} " \
          #       "for component `#{@component.name}`" unless reachable?
          @repository.branches[@branch]
        end

        def reachable?
          @repository.ref_exists?(@branch)
        end
      end
    end
  end
end
