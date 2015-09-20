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

        step :build_info do
          Logger.info 'Building components from lockfile ...'
        end

        step :verify_manifest do
          raise GitCompoundError,
                'Manifest md5sum has changed ! Use `update` command.' unless
            @manifest.md5sum == @lock.manifest
        end

        step :build_lock do
          @lock.process(Worker::ComponentDispatcher.new(@lock))
        end

        step :execute_tasks do
          subprocedure(:tasks_runner)
        end
      end
    end
  end
end
