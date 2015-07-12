module GitCompound
  module Worker
    # Worker that decides whether component
    # should be built, updated or replaced
    #
    class ComponentUpdateDispatcher < Worker
      def initialize(lock_old, lock_new)
        @lock_old = lock_old
        @lock_new = lock_new
        @print    = PrettyPrint.new
        @build    = ComponentBuilder.new(lock_new)
        @update   = ComponentUpdater.new(lock_new)
        @replace  = ComponentReplacer.new(lock_new)
      end

      def visit_component(component)
        @component = component

        case
        when component_needs_building?  then strategy = @build
        when component_needs_updating?  then strategy = @update
        when component_needs_replacing? then strategy = @replace
        else
          Logger.inline 'Unchanged: '
          @print.visit_component(component)
          @lock_new.lock_component(component)
          return
        end

        strategy.visit_component(component)
      end

      private

      # Component needs building if it's destination directory
      # does not exist
      #
      def component_needs_building?
        !@component.destination_exists?
      end

      # Component needs updating if is locked and, origin matches
      # and HEAD sha has changed
      #
      def component_needs_updating?
        locked = @lock_old.find(@component)

        locked && locked.origin == @component.origin &&
          locked.sha != @component.sha
      end

      # Component needs replacing if is locked and
      # origin does not match
      #
      def component_needs_replacing?
        locked = @lock_old.find(@component)
        locked && locked.origin != @component.origin
      end
    end
  end
end
