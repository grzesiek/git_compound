module GitCompound
  module Command
    # Class that parses command arguments
    #
    class Options
      GLOBAL_OPTIONS = [:verbose, :disable_colors]

      def initialize(args)
        @command, @args = parse_options(args)

        self.class.disable_colors = false
        set_global_options
      end

      def global_options
        @args & GLOBAL_OPTIONS
      end

      def command_options
        @args - GLOBAL_OPTIONS
      end

      def command
        @command || 'help'
      end

      def parse
        [command, command_options]
      end

      def self.verbose=(mode)
        GitCompound::Logger.verbose = mode
      end

      def self.disable_colors=(mode)
        GitCompound::Logger.colors = !mode
      end

      private

      def parse_options(args)
        opts_dash = args.select { |opt| opt.start_with?('--') }
        opts_string = args - opts_dash
        command = opts_string.shift
        opts_sym = opts_dash.collect { |opt| opt.sub(/^--/, '').gsub('-', '_').to_sym }
        [command, opts_string + opts_sym]
      end

      def set_global_options
        global_options.each do |option|
          self.class.public_send("#{option}=", true)
        end
      end
    end
  end
end
