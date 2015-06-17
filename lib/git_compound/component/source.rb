module GitCompound
  class Component
    # Component source
    #
    class Source
      attr_reader :location, :repository, :version

      def initialize(location, component)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          location.nil? || location.empty?

        @component  = component
        @location   = location
        @repository = Repository.factory(@location)
        @vstrategy  = @component.version_strategy
        @version    = @vstrategy.new(@repository, @component.version)
      end

      # Loads manifest from source repository
      #
      def manifest
        manifests = ['Compoundfile', '.gitcompound']
        raise DependencyError,
              "Version #{@version} unreachable" unless @version.reachable?

        contents = @repository.files_contents(manifests, @version.sha)
        Manifest.new(contents, @component)
      rescue FileNotFoundError
        nil
      end
    end
  end
end
