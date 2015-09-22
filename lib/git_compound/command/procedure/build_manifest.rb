module GitCompound
  module Command
    module Procedure
      # BuildManifest procedure class
      #
      class BuildManifest < Procedure
        include Element::Manifest
        include Element::Lock
        include Element::Subprocedure

        add_subprocedure :check_dependencies, Check
        add_subprocedure :tasks_runner,       Tasks

        step :build_info do
          Logger.info 'Building components ...'
        end

        step :check do
          subprocedure(:check_dependencies)
        end

        step :build_manifest do
          @manifest.process(Worker::ComponentBuilder.new(@lock))
        end

        step :execute_tasks do
          subprocedure(:tasks_runner)
        end

        step :lock_manifest do
          @lock.lock_manifest(@manifest)
          @lock.write
        end
      end
    end
  end
end
