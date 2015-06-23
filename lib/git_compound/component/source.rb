module GitCompound
  class Component
    # Component source
    #
    class Source
      extend Forwardable
      delegate clone: :@repository
      delegate ref: :@version

      attr_reader :origin, :repository, :version

      def initialize(origin, strategy, component)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          origin.nil? || origin.empty?

        @component  = component
        @origin     = origin
        @repository = Repository.factory(@origin)
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
    end
  end
end
