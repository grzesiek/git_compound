require 'pathname'

module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(component_path, component)
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          component_path.nil? || component_path.empty?

        raise CompoundSyntaxError,
              'Destination should contain at least one directory' unless
          Pathname.new(component_path).each_filename.count > 0

        @component = component
        @path      = expand_path(component_path)
      end

      def exists?
        FileTest.exist?(@path)
      end

      def repository
        destination_repository =
          Repository::RepositoryLocal.new(@path)
        yield destination_repository if block_given?
        destination_repository
      end

      private

      def expand_path(component_path)
        pathname = Pathname.new(component_path)

        unless pathname.absolute?
          ancestor_paths = @component.ancestors.map(&:path)
          pathname = Pathname.new('.').join(*ancestor_paths) + pathname
        end

        Pathname.new("./#{pathname}").cleanpath.to_s + '/'
      end
    end
  end
end
