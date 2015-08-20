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

        def execute
          Logger.info 'Building components ...'

          check_dependencies
          build_manifest
          execute_tasks
          lock_manifest
        end

        private

        def check_dependencies
          subprocedure(:check_dependencies)
        end

        def build_manifest
          @manifest.process(Worker::ComponentBuilder.new(@lock))
        end

        def execute_tasks
          subprocedure(:tasks_runner)
        end

        def lock_manifest
          @lock.lock_manifest(@manifest)
          @lock.write
        end
      end
    end
  end
end
