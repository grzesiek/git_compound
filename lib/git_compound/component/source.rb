require 'forwardable'

module GitCompound
  class Component
    # Component source
    #
    class Source
      extend Forwardable
      delegate [:sha, :ref] => :@version
      attr_reader :origin, :repository, :version, :options

      def initialize(origin, version, strategy, options, component)
        raise CompoundSyntaxError, 'Source cannot be empty' if
          origin.nil? || origin.empty?

        @origin     = origin
        @strategy   = strategy
        @options    = options
        @component  = component
        @repository = Repository.factory(@origin)
        @version    = strategy.new(@repository, version)
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
        @repository.clone(destination, clone_args)
      end

      private

      def clone_args
        raise CompoundSyntaxError,
              '`shallow` keyword not available for sha version strategy' if
          @options.include?(:shallow) && @strategy == Component::Version::SHA

        opts = []
        opts << "--branch '#{@version.ref}' --depth 1" if @options.include? :shallow
        opts.join(' ')
      end
    end
  end
end
