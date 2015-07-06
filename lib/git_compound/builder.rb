module GitCompound
  # Builder class, responsible for building project
  # from manifest or lockfile
  #
  class Builder
    def initialize(manifest, opts)
      @manifest = manifest
      @opts     = opts
    end

    def lock_initialize
      @lock ||= Lock.new
      self
    end

    def lock_write
      @lock.write
      self
    end

    def manifest_verify
      return self unless @manifest.md5sum == @lock.manifest

      raise GitCompoundError,
            'Manifest md5sum has changed ! Use `update` command instead'
    end

    def manifest_lock
      @lock.lock_manifest(@manifest)
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

    def components_build
      Logger.info 'Building components ...'
      Lock.exist? ? build_from_lock! : build_from_manifest!
      self
    end

    def components_update
      raise GitCompoundError,
            "Lockfile `#{Lock::FILENAME}` does not exist ! " \
            'You should use `build` command' unless Lock.exist?

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

    private

    def build_from_lock!
      Logger.info 'Using lockfile ...'
      @lock.build
    end

    def build_from_manifest!
      components = {}
      @manifest.process(Worker::ComponentBuilder.new,
                        Worker::ComponentsCollector.new(components))
      components.each_value { |component| @lock.lock_component(component) }
    end
  end
end
