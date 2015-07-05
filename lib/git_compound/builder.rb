module GitCompound
  # Builder class, responsible for building project
  # from manifest or lockfile
  #
  class Builder
    def initialize(manifest, opts)
      @manifest = manifest
      @opts     = opts
    end

    def build
      check

      Logger.info 'Building manifest ...'
      @manifest.process(Worker::ComponentBuilder.new)

      Logger.info 'Running tasks ...'
      if @opts.include?(:unsafe_stacked_tasks)
        @manifest.process(Worker::TaskRunner.new)
      else
        @manifest.tasks.each_value(&:execute)
      end
    end

    def update
    end

    def check
      Logger.info 'Checking dependencies ...'

      @manifest.process(
        Worker::CircularDependencyChecker.new,
        Worker::NameConstraintChecker.new,
        Worker::ConflictingDependencyChecker.new)
    end

    def show
      @manifest.process(
        Worker::CircularDependencyChecker.new,
        Worker::PrettyPrint.new)
    end
  end
end
