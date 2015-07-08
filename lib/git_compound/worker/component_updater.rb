module GitCompound
  module Worker
    # Worker that updates component
    #
    class ComponentUpdater < Worker
      def initialize(lock)
        @lock    = lock
        @print   = PrettyPrint.new
      end

      def visit_component(component)
        @component = component
        return unless component_needs_updating?

        Logger.inline 'Updating: '
        @print.visit_component(component)

        component.update
      end

      private

      # Unless component exists and match origin with locked
      # component, it needs replacement rather than update
      #
      def component_needs_updating?
        locked_component = @lock.find(@component) do |locked|
          @component.origin == locked.origin
        end

        locked_component &&
          locked_component.sha != @component.sha
      end
    end
  end
end
