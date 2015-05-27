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
        raise "Component `#{component.name}` invalid" unless component.valid?
      end

      def version(component_version)
        @component.version = component_version
        raise CompoundSyntaxError, 'Cannot use version with sha or branch' if
          [@component.sha, @component.branch].any?
      end

      def sha(component_sha)
        @component.sha = component_sha
        raise CompoundSyntaxError, 'Cannot use sha with version or branch' if
          [@component.version, @component.branch].any?
        raise CompoundSyntaxError, 'Invalid SHA1 format' unless
          component_sha.match(/[0-9a-f]{5,40}/)
      end

      def branch(component_branch)
        @component.branch = component_branch
        raise CompoundSyntaxError, 'Cannot use branch with version or sha' if
          [@component.version, @component.sha].any?
      end

      def source(component_source)
        @component.source = component_source
        raise CompoundSyntaxError, 'Source cannot be empty' if
          component_source.nil? || component_source.empty?
        @component.repository = GitRepository.factory(component_source)
      end

      def destination(component_destination_path)
        @component.destination = component_destination_path
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          component_destination_path.nil? || component_destination_path.empty?
      end
    end
  end
end
