module GitCompound
  class Component
    module Version
      # Component Gem-like version
      #
      class GemVersion < AbstractVersion
        attr_reader :requirement

        def initialize(repository, requirement)
          @repository  = repository
          @requirement = requirement
          raise CompoundSyntaxError, 'Malformed version requirement string' unless
            @requirement =~ Gem::Requirement::PATTERN
        end

        # Lastest matching version
        #
        def reference
          matches.first
        end

        def sha
          # TODO
          # raise DependencyError, 'No maching version available for ' \
          #       "`#{@component.name}` component" unless reachable?
          @repository.versions[reference]
        end

        def matches
          gem_versions = @repository.versions.map { |k, _| Gem::Version.new(k) }
          matching_versions = gem_versions.sort.reverse.select do |gem_version|
            dependency = Gem::Dependency.new('component', @requirement)
            dependency.match?('component', gem_version, false)
          end

          matching_versions.map(&:to_s)
        end

        def reachable?
          @repository.versions[reference] ? true : false
        end
      end
    end
  end
end
