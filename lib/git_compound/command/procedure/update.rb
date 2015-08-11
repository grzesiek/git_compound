module GitCompound
  module Command
    module Procedure
      # Update command procedure class
      #
      class Update < Procedure
        include Element::Manifest
        include Element::Lock

        def initialize(args)
          super
          @check = Check.new(args)
          @tasks = Tasks.new(args)
        end

        def execute
          raise GitCompoundError,
                "Lockfile `#{Lock::FILENAME}` does not exist ! " \
                'You should use `build` command.' unless Lock.exist?

          protect_local_modifications
          check_dependencies
          update
          lock_updated_manifest
          remove_dormant_components
        end

        private

        def protect_local_modifications
          @lock.process(Worker::LocalChangesGuard.new(@lock))
        end

        def check_dependencies
          @check.check
        end

        def update
          Logger.info 'Updating components ...'
          @manifest.process(Worker::ComponentDispatcher.new(@lock_new))
        end

        def execute_tasks
          @tasks.execute
        end

        def lock_updated_manifest
          @lock_new.lock_manifest(@manifest)
          @lock_new.write
        end

        def remove_dormant_components
          dormant_components = @lock.components.reject do |component|
            @lock_new.find(component) ? true : false
          end

          dormant_components.each do |component|
            Logger.warn "Removing dormant component `#{component.name}` " \
                        "from `#{component.path}` !"

            component.remove!
          end
        end
      end
    end
  end
end
