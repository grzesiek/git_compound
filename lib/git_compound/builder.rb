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

      @manifest.process(Worker::ComponentBuilder.new)

      if @opts.include?('--unsafe-stacked-tasks')
        @manifest.process(Worker::TaskRunner.new)
      else
        @manifest.tasks.each_value(&:execute)
      end
    end

    def update
    end

    def check
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
