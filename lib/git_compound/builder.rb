module GitCompound
  # Builder class, responsible for building project
  # from manifest or lockfile
  #
  class Builder
    def initialize(manifest, lock, opts)
      @manifest = manifest
      @lock     = lock
      @opts     = opts
    end

    def manifest_build
      Logger.info 'Building components ...'
      @manifest.process(Worker::ComponentBuilder.new(@lock))
      self
    end

    def manifest_update
      raise NotImplementedError
      Logger.info 'Updating components ...'
      @manifest.process(Worker::ComponentUpdater.new(@lock),
                        Worker::ComponentBuilder.new(@lock))
      self
    end

    def manifest_lock
      @lock.lock_manifest(@manifest)
      @lock.write
      self
    end

    def dependencies_check
      Logger.info 'Checking dependencies ...'

      @manifest.process(
        Worker::CircularDependencyChecker.new,
        Worker::NameConstraintChecker.new,
        Worker::ConflictingDependencyChecker.new)
      self
    end

    def components_show
      Logger.info 'Processing components list ...'
      @manifest.process(
        Worker::CircularDependencyChecker.new,
        Worker::PrettyPrint.new)
      self
    end

    def tasks_execute
      Logger.info 'Running tasks ...'

      if @opts.include?(:allow_nested_subtasks)
        @manifest.process(Worker::TaskRunner.new)
      else
        @manifest.tasks.each_value(&:execute)
      end
      self
    end

    def locked_manifest_verify
      return self if @manifest.md5sum == @lock.manifest
      raise GitCompoundError,
            'Manifest md5sum has changed ! Use `update` command.'
    end

    def locked_components_build
      Logger.info 'Building components from lockfile ...'
      @lock.process(Worker::ComponentBuilder.new(@lock))
      self
    end

    def locked_components_guard
      @lock.process(Worker::LocalChangesGuard.new(@lock))
      self
    end
  end
end
