module GitCompound
  module Logger
    # Debugger mixin
    #
    module Debugger
      def debug_before(method, &block)
        debug(method, :before, &block)
      end

      def debug_after(method, &block)
        debug(method, :after, &block)
      end

      private

      def debug(method, moment, &block)
        raise GitCompoundError, 'No block given !' unless block

        method_old = "#{method}_old_debugged".to_sym
        alias_method(method_old, method)
        private method_old

        define_method(method) do |*args|
          Logger.debug(instance_exec(*args, &block)) if moment == :before
          args.insert(0, send(method_old, *args))
          Logger.debug(instance_exec(*args, &block)) if moment == :after

          args.first
        end
      end
    end
  end
end
