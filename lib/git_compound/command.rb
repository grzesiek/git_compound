module GitCompound
  # GitCompount command facade
  #
  module Command
    def build(*args)
      builder(args).build
    end

    def update(*args)
      builder(args).update
    end

    def check(*args)
      builder(args).check
    end

    def show(*args)
      builder(args).show
    end

    def help(*_args)
      print_usage
    end

    def run(command, args)
      public_send(command, *args)
    rescue NoMethodError
      print_usage
    rescue GitCompoundError => e
      abort "[-] Error: #{e.message}"
    end

    private

    def builder(args)
      Builder.new(manifest(args.shift), args)
    end

    def manifest(filename)
      files = filename ? [filename] : ['Compoundfile', '.gitcompound']
      found = files.select { |file| File.exist?(file) }

      raise GitCompoundError,
            "Manifest `#{filename || files.inspect}` not found !" if found.empty?

      contents = File.read(found.first)
      Manifest.new(contents)
    end

    def print_usage
      puts <<-END
GitCompound version #{GitCompound::VERSION}

Usage:
    gitcompound build [ manifest ]
      -- builds project from manifest

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
