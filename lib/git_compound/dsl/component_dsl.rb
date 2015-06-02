module GitCompound
  # Compound Domain Specific Language
  #
  module Dsl
    # DSL for Component
    #
    class ComponentDsl
      def initialize(component, &block)
        @component = component
        instance_eval(&block)
      end

      def version(component_version)
        raise CompoundSyntaxError,
              'Component version already set' if @component.version
        @component.version =
          Component::Version::GemVersion.new(@component, component_version)
      end

      def sha(component_sha)
        raise CompoundSyntaxError, 'Invalid SHA1 format' unless
          component_sha.match(/[0-9a-f]{5,40}/)
        raise CompoundSyntaxError,
              'Component version already set' if @component.version
        @component.version =
          Component::Version::SHA.new(@component, component_sha)
      end

      def branch(component_branch)
        raise CompoundSyntaxError,
              'Component version already set' if @component.version
        @component.version =
          Component::Version::Branch.new(@component, component_branch)
      end

      def source(component_source)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          component_source.nil? || component_source.empty?
        @component.source =
          Component::Source.new(@component, component_source)
      end

      def destination(component_destination)
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          component_destination.nil? || component_destination.empty?
        @component.destination =
          Component::Destination.new(@component, component_destination)
      end
    end
  end
end
