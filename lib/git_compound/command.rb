module GitCompound
  module Command
    def build(*args)
      manifest(args.first).process(
        Worker::CircularDependencyChecker.new,
        Worker::NameConstraintChecker.new,
        Worker::ConflictingDependencyChecker.new,
        Worker::ComponentBuilder.new)
    end

    def update(*args)
      raise NotImplementedError
    end

    def show(*args)
    end

    def run(command, args)
      public_send(command, *args)
    end

    private

    def manifest(filename)
      files = filename ? [ filename ] : [ 'Compoundfile', '.gitcompound' ]
      files.select! { |file| File.exist?(file) }

      raise GitCompoundError,
            "None of `#{files.inspect}` manifests found !" if files.empty?

      contents = File.read(files.first)
      Manifest.new(contents)
    end
  end
end
