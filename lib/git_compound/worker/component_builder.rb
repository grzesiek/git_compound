module GitCompound
  module Worker
    # Worker that builds components
    #
    class ComponentBuilder < Worker
      def initialize(lock = nil)
        @lock  = lock
        @print = PrettyPrint.new
      end

      def visit_component(component)
        @component = component
        return unless component_needs_building?

        Logger.inline 'Building:  '
        @print.visit_component(component)

        component.build

        raise GitCompoundError,
              "Destination  `#{component.destination_path}` " \
              'verification failed !' unless component.destination_exists?

        @lock.lock_component(component) if @lock
      end

      private

      # This method checks if lockfile is set and:
      #
      # * it will raise exception if component already exists and lock
      #   is not set
      # * it will return true/false, what will either prevent component
      #   from building or permit build (quietly) if lock is set
      #
      def component_needs_building?
        already_built = @component.destination_exists?
        return !already_built if @lock

        raise GitCompoundError,
              "Destination directory `#{@component.destination_path}` " \
              'already exists !' if already_built

        true
      end
    end
  end
end
