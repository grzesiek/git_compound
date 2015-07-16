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
              "Destination directory `#{component.path}` " \
              'already exists !' if component.exists?

        Logger.inline 'Building:  '
        @print.visit_component(component)

        component.build!

        raise GitCompoundError,
              "Destination  `#{component.path}` " \
              'verification failed !' unless component.exists?

        return unless @lock
        @lock.lock_component(component) unless @lock.find(component)
      end
    end
  end
end
