module GitCompound
  # Task module and factory
  #
  module Task
    extend self

    def factory(name, type, manifest, &block)
      case
      # manifest task
      when type.nil? || type == :manfiest then task_class = TaskSingle
      # task for each component defined in manifest
      when type == :each                  then task_class = TaskEach
      # task for all descendant components of manifest
      when type == :all                   then task_class = TaskAll
      else
        raise GitCompoundError, "Unrecognized task type `#{type}`"
      end

      task_class.new(name, manifest, &block)
    end
  end
end
