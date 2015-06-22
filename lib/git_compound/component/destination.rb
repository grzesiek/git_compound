module GitCompound
  class Component
    # Component destination
    #
    class Destination
      attr_reader :path

      def initialize(path, component)
        @path      = path
        @component = component
        raise CompoundSyntaxError, 'Destination cannot be empty' if
          path.nil? || path.empty?
      end

      def absolute
        return format_path(@path) if @path.start_with?('/')

        components = @component.ancestors
        absolute = components.each_with_object('') do |ancestor, path|
          path << ancestor.destination.absolute
        end << @path

        format_path(absolute)
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
