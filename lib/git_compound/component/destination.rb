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

      def absolute_path
        return format_path(@path) if @path.start_with?('/')

        components = @component.ancestors
        absolute_path = components.each_with_object('') do |ancestor, path|
          path << ancestor.destination.absolute_path
        end << @path

        format_path(absolute_path)
      end

      def exists?
        File.directory?(absolute_path)
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
