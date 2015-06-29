module GitCompound
  class Component
    module Version
      # Component version as tag
      #
      class Tag < VersionStrategy
        def initialize(repository, tag)
          @repository = repository
          @tag        = tag
        end

        def ref
          @tag
        end

        def sha
          @repository.tags[@tag]
        end

        def reachable?
          @repository.tags.key?(@tag)
        end

        def to_s
          "tag: #{@tag}"
        end
      end
    end
  end
end
