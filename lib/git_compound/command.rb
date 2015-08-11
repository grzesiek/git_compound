module GitCompound
  # GitCompount command facade
  #
  module Command
    def build(*args)
      if Lock.exist?
        builder(args)
          .locked_manifest_verify
          .locked_components_build
          .tasks_execute
      else
        builder(args)
          .dependencies_check
          .manifest_build
          .tasks_execute
          .manifest_lock
      end
    end

    def update(*args)
      execute(Procedure::Update, args)
    end

    def check(*args)
      execute(Procedure::Check, args)
    end

    def show(*args)
      execute(Procedure::Show, args)
    end

    def help(*args)
      execute(Procedure::Help, args)
    end

    def run(command, args)
      abort(Procedure::Help.message) unless methods.include?(command.to_sym)
      public_send(command, *args)
    rescue GitCompoundError => e
      abort "Error: #{e.message}".on_red.white.bold
    end

    private

    def execute(procedure, args)
      procedure.new(args).execute
    end

    def builder(args)
      filename = args.find { |arg| arg.is_a? String }
      Builder.new(manifest(filename), Lock.new, args)
    end

    def manifest(filename)
      files = filename ? [filename] : Manifest::FILENAMES
      found = files.select { |file| File.exist?(file) }

      raise GitCompoundError,
            "Manifest `#{filename || files.inspect}` not found !" if found.empty?

      contents = File.read(found.first)
      Manifest.new(contents)
    end
  end
end
