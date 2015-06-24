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

    def check(*args)
      manifest(args.first).process(
        Worker::CircularDependencyChecker.new,
        Worker::NameConstraintChecker.new,
        Worker::ConflictingDependencyChecker.new)
    end

    def show(*args)
      manifest(args.first).process(
        Worker::CircularDependencyChecker.new,
        Worker::PrettPrint.new)
    end

    def help(*args)
      print_usage
    end

    def run(command, args)
      public_send(command, *args)
    rescue NoMethodError
      print_usage
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

    def print_usage
      puts <<-END
      Usage: ...
      END
    end
  end
end
