module GitCompound
  module Worker
    # Worker that replaces components if necessary
    #
    class ComponentReplacer < Worker
      def initialize(lock)
        @lock  = lock
        @print = PrettyPrint.new
      end

      def visit_component(component)
        raise "Component `#{component.name}` is not built !" unless
          component.exists?

        Logger.inline 'Replacing: '
        @print.visit_component(component)

        component.remove!
        component.build!

        @lock.lock_component(component)
      end
    end
  end
end
