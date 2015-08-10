module GitCompound
  module Command
    # Help command procedure
    #
    class Help < Procedure
      def execute
        Logger.info(message)
      end

      def message
        self.class.message
      end

      # rubocop:disable Metrics/AbcSize
      def self.message
        <<-EOS
      #{'GitCompound version'.bold.yellow} #{GitCompound::VERSION.bold}

      Usage: #{'gitcompound'.bold.green}
        #{'[options]'.green} #{'command'.bold} #{'[manifest_file]'.green}

      Commands:
        #{'build'.bold}
            builds project from manifest (or lockfile if present)

            If manifest is not specified it uses one of
            #{Manifest::FILENAMES.inspect}

        #{'update'.bold}
            updates project

        #{'check'.bold}
            detects circular depenencies, conflicting dependencies
            and checks for name contraints

        #{'show'.bold}
            prints structure of project

        #{'help'.bold}
            prints this help

      Options:'
        #{'--verbose'.bold}
            prints verbose log info

        #{'--disable-colors'.bold}
            disable ANSI colors in output
        EOS
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
