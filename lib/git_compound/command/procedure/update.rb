module GitCompound
  module Command
    module Procedure
      # Update command procedure class
      #
      class Update < Procedure
        include Element::Manifest
        include Element::Lock
        include Element::Subprocedure

        add_subprocedure :check_dependencies, Check
        add_subprocedure :tasks_runner,       Tasks

        step :check_lockfile do
          raise GitCompoundError,
                "Lockfile `#{Lock::FILENAME}` does not exist ! " \
                'You should use `build` command.' unless locked?
        end

        step :protect_local_modifications do
          @lock.process(Worker::LocalChangesGuard.new(@lock))
        end

        step :check_dependencies do
          subprocedure(:check_dependencies)
        end

        step :update do
          Logger.info 'Updating components ...'
          @manifest.process(Worker::ComponentDispatcher.new(@lock_new))
        end

        step :execute_tasks do
          subprocedure(:tasks_runner)
        end

        step :lock_updated_manifest do
          @lock_new.lock_manifest(@manifest)
          @lock_new.write
        end

        step :remove_dormant_components do
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
