require 'forwardable'

module GitCompound
  class Component
    # Component source
    #
    class Source
      extend Forwardable
      delegate ref: :@version

      attr_reader :origin, :repository, :version

      def initialize(origin, strategy, options, component)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          origin.nil? || origin.empty?

        @component  = component
        @origin     = origin
        @options    = options
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
        Manifest.new(nil, @component)
      end

      def clone(destination)
        # it can be string pointed by :options key
        opts = @options[:options] if @options
        opts = "--branch '#{@version.ref}' --depth 1" if
          @options == { shallow: true }

        @repository.clone(destination, opts)
      end
    end
  end
end
