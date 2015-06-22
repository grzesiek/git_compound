module GitCompound
  class Component
    # Component source
    #
    class Source
      attr_reader :location, :repository, :version

      def initialize(location, strategy, component)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          location.nil? || location.empty?

        @component  = component
        @location   = location
        @repository = Repository.factory(@location)
        @version    = strategy.new(@repository, @component.version)
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

      # Clones source repository to component destination
      #
      def clone
#        destination = @component.destination
#        destination_path = destination.absolute_path
#        @repository.clone(destination_path)
#        destination_path
      end
    end
  end
end
