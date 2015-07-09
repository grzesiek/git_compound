require 'pathname'

module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(path, component)
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          path.nil? || path.empty?

        @path      = path
        @component = component
      end

      def expanded_path
        pathname = Pathname.new(@path)

        unless pathname.absolute?
          ancestor_paths = @component.ancestors.map(&:destination_path)
          pathname = Pathname.new('.').join(*ancestor_paths) + pathname
        end

        Pathname.new("./#{pathname}").cleanpath.to_s + '/'
      end

      def exists?
        FileTest.exist?(expanded_path)
      end

      def repository
        destination_repository =
          Repository::RepositoryLocal.new(expanded_path)
        yield destination_repository if block_given?
        destination_repository
      end
    end
  end
end
