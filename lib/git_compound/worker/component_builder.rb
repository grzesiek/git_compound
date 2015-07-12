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
        raise GitCompoundError,
              "Destination directory `#{component.destination_path}` " \
              'already exists !' if component.destination_exists?

        Logger.inline 'Building:  '
        @print.visit_component(component)

        component.build

        raise GitCompoundError,
              "Destination  `#{component.destination_path}` " \
              'verification failed !' unless component.destination_exists?

        @lock.lock_component(component) if @lock
      end
    end
  end
end
