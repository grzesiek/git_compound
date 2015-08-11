module GitCompound
  module Command
    module Procedure
      # Check command procedure class
      #
      class Tasks < Procedure
        include Element::Manifest

        def initialize(args)
          super
        end

        def execute
          Logger.info 'Running tasks ...'

          if @args.include?(:allow_nested_subtasks)
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
