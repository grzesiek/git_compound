module GitCompound
  module Command
    module Procedure
      # BuildLock procedure class
      #
      class BuildLock < Procedure
        include Element::Manifest
        include Element::Lock
        include Element::Subprocedure

        add_subprocedure :tasks_runner, Tasks

        def execute
          Logger.info 'Building components from lockfile ...'

          verify_manifest
          build_locked_components
          execute_tasks
        end

        private

        def verify_manifest
          return if @manifest.md5sum == @lock.manifest

          raise GitCompoundError,
                'Manifest md5sum has changed ! Use `update` command.'
        end

        def build_locked_components
          @lock.process(Worker::ComponentDispatcher.new(@lock))
        end

        def execute_tasks
          subprocedure(:tasks_runner)
        end
      end
    end
  end
end
