module GitCompound
  class Component
    module Version
      # Component version class
      #
      class GemVersion < AbstractVersion
        attr_reader :requirement

        def initialize(component, requirement)
          @requirement = requirement
          @component   = component
          raise CompoundSyntaxError, 'Malformed version requirement string' unless
            @requirement =~ Gem::Requirement::PATTERN
        end

        # Lastest matching version
        #
        def reference
          matches.first
        end

        def sha
          raise DependencyError, 'No maching version available for ' \
                "`#{@component.name}` component" unless reachable?
          @component.source.repository.versions[reference]
        end

        def matches
          repository = @component.source.repository

          gem_versions = repository.versions.map { |k, _| Gem::Version.new(k) }
          matching_versions = gem_versions.sort.reverse.select do |gem_version|
            dependency = Gem::Dependency.new('component', @requirement)
            dependency.match?('component', gem_version, false)
          end

          matching_versions.map(&:to_s)
        end

        def reachable?
          !@component.source.repository.versions[reference].nil?
        end
      end
    end
  end
end
