module GitCompound
  module Worker
    # Worker that replaces components if necessary
    #
    class ComponentReplacer < Worker
      def initialize(lock_old, lock_new)
        @lock_old = lock_old
        @lock_new = lock_new
        @print    = PrettyPrint.new
      end

      def visit_component(component)
        locked = @lock_old.find(component)

        raise GitCompoundError, 'Component not locked !' unless locked

        Logger.warn "Replacing `#{locked.name}` component with `#{component.name}` !"
        Logger.inline 'Replacing: '
        @print.visit_component(component)

        locked.remove!
        component.build

        @lock_new.lock_component(component)
      end
    end
  end
end
