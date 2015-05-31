module GitCompound
  class Component
    # Component version class
    #
    class Version
      attr_reader :requirement

      def initialize(component, requirement)
        @requirement = requirement
        @component   = component
        raise CompoundSyntaxError, 'Malformed version requirement string' unless
          @requirement =~ Gem::Requirement::PATTERN
      end

      def matches
        gem_versions = repository_versions.map { |k, _| Gem::Version.new(k) }
        matching_versions = gem_versions.sort.reverse.select do |gem_version|
          dependency = Gem::Dependency.new('component', @requirement)
          dependency.match?('component', gem_version, false)
        end

        matching_versions.map(&:to_s)
      end

      def lastest_matching_version
        matches.first
      end

      def lastest_matching_sha
        repository_versions[lastest_matching_version]
      end

      private

      def repository_versions
        @component.repository.versions
      end
    end
  end
end
