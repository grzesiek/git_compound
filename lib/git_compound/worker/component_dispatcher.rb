module GitCompound
  module Worker
    # Worker that decides whether component
    # should be built, updated or replaced
    #
    class ComponentDispatcher < Worker
      def initialize(lock)
        @lock    = lock
        @print   = PrettyPrint.new
        @build   = ComponentBuilder.new(lock)
        @update  = ComponentUpdater.new(lock)
        @replace = ComponentReplacer.new(lock)
      end

      def visit_component(component)
        @component  = component
        @repository = component.repository if component.exists?

        case
        when component_needs_building?  then strategy = @build
        when component_needs_updating?  then strategy = @update
        when component_needs_replacing? then strategy = @replace
        else
          Logger.inline 'Unchanged: '
          @print.visit_component(component)
          @lock.lock_component(component)
          return
        end

        strategy.visit_component(component)
      end

      private

      # Component needs building if it's destination directory
      # does not exist
      #
      def component_needs_building?
        !@component.exists?
      end

      # Component needs updating if it exists, remote origin matches
      # new component origin and HEAD sha has changed
      #
      def component_needs_updating?
        return false unless @component.exists?

        @repository.origin_remote =~ /#{@component.origin}$/ &&
          @repository.head_sha != @component.sha
      end

      # Component needs replacing if it exists but repository
      # remote origin  does not match new component origin
      #
      def component_needs_replacing?
        return false unless @component.exists?

        !(@repository.origin_remote =~ /#{@component.origin}$/)
      end
    end
  end
end
