module GitCompound
  # GitCompount command facade
  #
  module Command
    def build(*args)
      if Lock.exist?
        builder(args)
          .manifest_verify
          .locked_build
          .tasks_execute
      else
        builder(args)
          .dependencies_check
          .manifest_build
          .tasks_execute
          .manifest_lock
      end
    end

    def update(*_args)
      raise GitCompoundError,
            "Lockfile `#{Lock::FILENAME}` does not exist ! " \
            'You should use `build` command' unless Lock.exist?

      raise NotImplementedError
    end

    def check(*args)
      builder(args).dependencies_check
      Logger.info 'OK'
    end

    def show(*args)
      builder(args).components_show
    end

    def help(*_args)
      Logger.info usage
    end

    def run(command, args)
      abort(usage) unless methods.include?(command.to_sym)
      public_send(command, *args)
    rescue GitCompoundError => e
      abort "[-] Error: #{e.message}"
    end

    private

    def builder(args)
      opts = args.select { |opt| opt.start_with?('--') }
      opts.collect! { |opt| opt.sub(/^--/, '').gsub('-', '_').to_sym }
      Builder.new(manifest(args.first), Lock.new, opts)
    end

    def manifest(filename)
      files = filename ? [filename] : ['Compoundfile', '.gitcompound']
      found = files.select { |file| File.exist?(file) }

      raise GitCompoundError,
            "Manifest `#{filename || files.inspect}` not found !" if found.empty?

      contents = File.read(found.first)
      Manifest.new(contents)
    end

    def usage
      <<-END
GitCompound version #{GitCompound::VERSION}

Usage:
    gitcompound build [ manifest ]
      -- builds project from manifest (or lockfile if present)

         If manifest is not specified it uses `Compoundfile`
         or `.gitcompound`

    gitcompound update [ manifest ]
      -- updates project

    gitcompound check [ manifest ]
      -- detects circular depenencies, conflicting dependencies
         and checks for name contraints

    gitcompound show [ manifest ]
      -- prints structure of project

    gitcompound help
      -- prints this help
      END
    end
  end
end
