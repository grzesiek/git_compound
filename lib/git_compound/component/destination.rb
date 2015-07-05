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
        return format_path(@path) if @path.start_with?('/')

        components = @component.ancestors
        expanded_path = components.each_with_object('') do |ancestor, path|
          path << ancestor.destination.expanded_path
        end << @path

        format_path(expanded_path)
      end

      def exists?
        File.directory?(expanded_path)
      end

      def repository
        destination_repository =
          Repository::RepositoryLocal.new(expanded_path)
        yield destination_repository if block_given?
        destination_repository
      end

      private

      def format_path(path)
        path = path[1..-1] if path.start_with?('/')
        path << '/' unless path.end_with?('/')
        path
      end
    end
  end
end
