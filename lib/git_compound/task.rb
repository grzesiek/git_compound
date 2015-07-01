module GitCompound
  # Task module and factory
  #
  module Task
    # rubocop:disable Style/ModuleFunction
    extend self

    def factory(name, type, manifest, &block)
      return TaskSingle.new(name, manifest, &block) if
        type.nil? || type == :manfiest
      return TaskEach.new(name, manifest.components, &block) if
        type == :each # each component in manifest
      return TaskAll.new(name, manifest, &block) if
        type == :all  # all descendant components of manifest

      raise GitCompoundError, "Unrecognized task type `#{type}`"
    end
    # rubocop:enable Style/ModuleFunction
  end
end
