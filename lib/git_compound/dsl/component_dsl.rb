module GitCompound
  # Compound Domain Specific Language
  #
  module DSL
    # DSL for Component
    #
    class ComponentDSL
      def initialize(component, &block)
        @component = component
        instance_eval(&block)
      end

      def version(component_version)
        raise CompoundSyntaxError,
              'Version already set (branch, sha ?)' if @component.version

        @component.version          = component_version
        @component.version_strategy = Component::Version::GemVersion
      end

      def sha(component_sha)
        raise CompoundSyntaxError,
              'Version already set (version, branch ?)' if @component.version
        raise CompoundSyntaxError, 'Invalid SHA1 format' unless
          component_sha.match(/[0-9a-f]{5,40}/)

        @component.version_strategy = Component::Version::SHA
        @component.version = component_sha
      end

      def branch(component_branch)
        raise CompoundSyntaxError,
              'Version already set (sha, branch ?)' if @component.version

        @component.version_strategy = Component::Version::Branch
        @component.version          = component_branch
      end

      def source(component_source)
        raise CompoundSyntaxError,
              'Version/branch/sha needed first' unless @component.version

        @component.source =
          Component::Source.new(component_source, @component)
      end

      def destination(component_path)
        @component.destination = Component::Destination.new(component_path)
      end
    end
  end
end
