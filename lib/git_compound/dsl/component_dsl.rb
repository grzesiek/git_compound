module GitCompound
  # Compound Domain Specific Language
  #
  module Dsl
    # DSL for Component
    #
    class ComponentDsl
      def initialize(&block)
        instance_eval(&block)
      end

      def version(component_version)
        @version = component_version
        raise CompoundSyntaxError, 'Cannot use version with sha or branch' if
          [@sha, @branch].any?
      end

      def sha(component_sha)
        @sha = component_sha
        raise CompoundSyntaxError, 'Cannot use sha with version or branch' if
          [@version, @branch].any?
        raise CompoundSyntaxError, 'Invalid SHA1 format' unless
          @sha.match(/[0-9a-f]{5,40}/)
      end

      def branch(component_branch)
        @branch = component_branch
        raise CompoundSyntaxError, 'Cannot use branch with version or sha' if
          [@version, @sha].any?
      end

      def source(component_source)
        @source = component_source
        raise CompoundSyntaxError, 'Source cannot be empty' if
          @source.nil? || @source.empty?
        @repository = GitRepository.factory(@source)
      end

      def destination(component_destination_path)
        @destination = component_destination_path
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          @destination.nil? || @destination.empty?
      end
    end
  end
end
