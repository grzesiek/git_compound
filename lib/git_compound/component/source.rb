module GitCompound
  class Component
    # Component source
    #
    class Source
      attr_reader :location, :repository

      def initialize(component, source)
        @location   = source
        @component  = component
        @repository = Repository.factory(@location)
      end

      # Loads manifest from source repository
      #
      def manifest
        manifests = ['Compoundfile', '.gitcompound']
        sha = @component.version.sha
        contents = @repository.files_contents(manifests, sha)
        Manifest.new(contents)
      rescue FileNotFoundError
        nil
      end
    end
  end
end
