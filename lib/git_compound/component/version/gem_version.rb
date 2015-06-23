module GitCompound
  class Component
    module Version
      # Component Gem-like version
      #
      class GemVersion < VersionStrategy
        attr_reader :requirement

        def initialize(repository, requirement)
          raise CompoundSyntaxError, 'Malformed version requirement string' unless
            requirement =~ Gem::Requirement::PATTERN

          @repository  = repository
          @requirement = requirement
        end

        def lastest_version
          matches.first
        end

        def ref
          lastest_version.tag
        end

        def sha
          lastest_version.sha
        end

        def matches
          versions = @repository.versions
          versions.select! { |version| version.matches?(@requirement) }
          versions.sort.reverse
        end

        def reachable?
          matches.any?
        end

        def to_s
          "gem version: #{@requirement}"
        end
      end
    end
  end
end
