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
        raise "Component `#{component.name}` is not built !" unless
          component.destination_exists?

        Logger.inline 'Updating:  '
        @print.visit_component(component)

        component.update

        @lock.lock_component(component)
      end
    end
  end
end
