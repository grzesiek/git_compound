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

    def manifest_verify
      return self if @manifest.md5sum == @lock.manifest

      raise GitCompoundError,
            'Manifest md5sum has changed ! Use `update` command instead'
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

    def manifest_build
      Logger.info 'Building manifest ...'
      components = {}
      @manifest.process(Worker::ComponentBuilder.new,
                        Worker::ComponentsCollector.new(components))
      components.each_value { |component| @lock.lock_component(component) }
      self
    end

    def manifest_update
      Logger.info 'Updating components ...'
      @manifest.process(Worker::ComponentUpdater.new(@lock))
      self
    end

    def components_show
      @manifest.process(
        Worker::CircularDependencyChecker.new,
        Worker::PrettyPrint.new)
      self
    end

    def tasks_execute
      Logger.info 'Running tasks ...'

      if @opts.include?(:unsafe_stacked_tasks)
        @manifest.process(Worker::TaskRunner.new)
      else
        @manifest.tasks.each_value(&:execute)
      end

      self
    end

    def locked_build
      Logger.info 'Building components from lockfile ...'
      @lock.build
      self
    end

    def lock_write
      self
    end
  end
end
