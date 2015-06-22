module GitCompound
  module Worker
    # Worker that detects if component name and its manifest name matches
    # This is important because it is additional verification of consistency
    # of manifests
    #
    class NameConstraintChecker < Worker
      def visit_component(component)
        return unless component.manifest # component does not have manifest

        component_name = component.name
        manifest_name  = component.manifest.name

        return if component_name == manifest_name
        raise NameConstraintError, "Name of component `#{component_name}` " \
          "does not match name in its manifest (`#{manifest_name}`) !"
      end
    end
  end
end
