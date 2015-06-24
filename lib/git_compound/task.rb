module GitCompound
  # Task module and factory
  #
  module Task
    # rubocop:disable Style/ModuleFunction
    extend self

    def factory(name, type, manifest, &block)
      return TaskSingle.new(name, manifest.parent, &block) if
        type.nil? || type == :once
      return TaskMulti.new(name, manifest.components, &block) if
        type == :each

      raise GitCompoundError, "Unrecognized task type `#{type}`"
    end
    # rubocop:enable Style/ModuleFunction
  end
end
