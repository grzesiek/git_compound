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
      raise GitCompoundError,
            "Lockfile `#{Lock::FILENAME}` does not exist ! " \
            'You should use `build` command.' unless Lock.exist?

      builder(args)
        .locked_components_guard
        .dependencies_check
        .manifest_update
        .tasks_execute
        .manifest_lock
        .locked_dormant_components_remove
    end

    def check(*args)
      builder(args).dependencies_check
      Logger.info 'OK'
    end

    def show(*args)
      builder(args).components_show
    end

    def help(*args)
      Help.new(args).execute
    end

    def run(command, args)
      abort(Help.message) unless methods.include?(command.to_sym)
      public_send(command, *args)
    rescue GitCompoundError => e
      abort "Error: #{e.message}".on_red.white.bold
    end

    private

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
