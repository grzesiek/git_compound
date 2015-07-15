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

    def help(*_args)
      Logger.info(usage)
    end

    def run(command, args)
      abort(usage) unless methods.include?(command.to_sym)

      Logger.debug("GitCompound v#{GitCompound::VERSION}")
      Logger.debug("Running command '#{command}'")

      public_send(command, *args)
    rescue GitCompoundError => e
      abort Logger.error("Error: #{e.message}", :quiet)
    end

    private

    def builder(args)
      Builder.new(manifest(args.first), Lock.new, args)
    end

    def manifest(filename)
      files = filename ? [filename] : Manifest::FILENAMES
      found = files.select { |file| File.exist?(file) }

      raise GitCompoundError,
            "Manifest `#{filename || files.inspect}` not found !" if found.empty?

      contents = File.read(found.first)
      Manifest.new(contents)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def usage
      usage_lines = [nil]
      usage_lines << ['GitCompound version'.bold.yellow,
                      GitCompound::VERSION.bold].join(' ')
      usage_lines << nil
      usage_lines << ['Usage:', 'gitcompound'.bold.green, '[options]'.green,
                      'command'.bold, '[manifest_file]'.green].join(' ')
      usage_lines << nil
      usage_lines << 'Commandsi:'
      usage_lines << '  build'.bold
      usage_lines << '      builds project from manifest (or lockfile if present)'
      usage_lines << nil
      usage_lines << '      If manifest is not specified it uses `Compoundfile`'
      usage_lines << '      or `.gitcompound`'
      usage_lines << nil
      usage_lines << '  update'.bold
      usage_lines << '      updates project'
      usage_lines << nil
      usage_lines << '  check'.bold
      usage_lines << '      detects circular depenencies, conflicting dependencies'
      usage_lines << '      and checks for name contraints'
      usage_lines << nil
      usage_lines << '  show'.bold
      usage_lines << '      prints structure of project'
      usage_lines << nil
      usage_lines << '  help'.bold
      usage_lines << '      prints this help'
      usage_lines << nil
      usage_lines << 'Options:'
      usage_lines << '  --verbose'.bold
      usage_lines << '      prints verbose log info'
      usage_lines << '  --disable-colors'.bold
      usage_lines << '      disable ANSI colors in output'

      usage_lines.join("\n")
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
  end
end
