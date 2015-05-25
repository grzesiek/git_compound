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
      rescue => e
        raise CompoundSyntaxError, e
      end

      def version(component_version)
        @component.version = component_version
      end

      def sha(component_sha)
        @component.sha = component_sha
      end

      def branch(component_branch)
        @component.branch = component_branch
      end

      def source(component_source)
        @component.source = component_source
      end

      def destination(component_destination_path)
        @component.destination = component_destination_path
      end
    end
  end
end
