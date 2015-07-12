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

      # Custom version strategy, also available via DSL
      #
      def version_strategy(version, strategy)
        raise CompoundSyntaxError,
              'Version strategy already set !' if @version_strategy

        @version = version
        @version_strategy = strategy
      end

      def version(component_version)
        version_strategy(component_version, Component::Version::GemVersion)
      end

      def branch(component_branch)
        version_strategy(component_branch, Component::Version::Branch)
      end

      def tag(component_tag)
        version_strategy(component_tag, Component::Version::Tag)
      end

      def sha(component_sha)
        raise CompoundSyntaxError, 'Invalid SHA1 format' unless
          component_sha.match(/[0-9a-f]{5,40}/)

        version_strategy(component_sha, Component::Version::SHA)
      end

      def source(component_source, *source_options)
        raise CompoundSyntaxError,
              'Version/branch/tag/sha needed first' unless @version

        @component.source =
          Component::Source.new(component_source,
                                @version,
                                @version_strategy,
                                source_options,
                                @component)
      end

      def destination(component_path)
        @component.destination =
          Component::Destination.new(component_path, @component)
      end
    end
  end
end
