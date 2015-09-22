module GitCompound
  module Command
    module Procedure
      # Check command procedure class
      #
      class Tasks < Procedure
        include Element::Manifest
        include Element::Option

        add_parameter :allow_nested_subtasks, type: :boolean, scope: :global

        step :tasks do
          Logger.info 'Running tasks ...'

          if @opts[:allow_nested_subtasks]
            @manifest.process(Worker::TaskRunner.new)
          else
            @manifest.tasks.each_value do |task|
              Worker::TaskRunner.new.visit_task(task)
            end
          end
        end
      end
    end
  end
end
