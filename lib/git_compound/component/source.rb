module GitCompound
  class Component
    # Component source
    #
    class Source
      attr_reader :location, :repository, :version

      def initialize(source, version_strategy, version)
        @location   = source
        @repository = Repository.factory(@location)
        @version    = version_strategy.new(@repository, version)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          source.nil? || source.empty?
      end

      # Loads manifest from source repository
      #
      def manifest
        manifests = ['Compoundfile', '.gitcompound']
        raise DependencyError,
              "Version #{@version} unreachable" unless @version.reachable?
        contents = @repository.files_contents(manifests, @version.sha)
        Manifest.new(contents)
      rescue FileNotFoundError
        nil
      end
    end
  end
end
