module GitCompound
  module Worker
    # Worker that prints dependency tree
    #
    class PrettyPrint < Worker
      def visit_component(component)
        pretty_print(component, " `#{component.name}` component, #{component.version}")
      end

      def visit_manifest(manifest)
        details = []
        details << "Component: #{manifest.name}" unless manifest.name.empty?
        details << "Maintainer: #{manifest.maintainer.join(', ')}" unless
          manifest.maintainer.empty?
        details << 'Dependencies:' unless manifest.components.empty?

        pretty_print(manifest, *details)
      end

      private

      def pretty_print(element, *messages)
        messages.each do |message|
          Logger.inline '    ' * element.ancestors.count
          Logger.info message
        end
      end
    end
  end
end
