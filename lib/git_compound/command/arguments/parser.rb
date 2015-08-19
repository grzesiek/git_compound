module GitCompound
  module Command
    module Arguments
      # Class responsible for parsing ARGV for given procedure
      #
      class Parser
        def initialize(argv, global)
          @global = global
          @args   = format_arguments(argv)
        end

        def procedure
          Command.const_get("Procedure::#{command.capitalize}")
        rescue
          Procedure::Help
        end

        def options
          expected  = procedure.options
          arguments = @args - @global - [command]
          found = {}

          option_each(expected) do |name, type|
            option = type.new(name, arguments)
            next unless option.valid?

            arguments -= option.used
            found.merge!(option.parse)
          end

          return found if arguments.empty?
          raise UnknownArgumentError,
                "Unknown arguments `#{arguments.inspect}`"
        end

        def global
          @args & @global
        end

        def command
          @args.find { |arg| arg.is_a?(String) }
        end

        private

        def format_arguments(argv)
          argv.map do |arg|
            arg.start_with?('--') ? arg.sub(/^--/, '').tr('-', '_').to_sym : arg
          end
        end

        def option_each(expected)
          # parameters first, arguments last
          opts = expected.sort_by { |_key, value| value[:variant] }.reverse

          opts.each do |opt|
            name = opt.first
            type = option_type(opt.last)

            yield name, type
          end
        end

        def option_type(metadata)
          variant = metadata[:variant].capitalize
          type = metadata[:type].capitalize
          Arguments::Type.const_get("#{variant}::#{type}")
        rescue NameError
          raise GitCompoundError,
                "Unknown option variant or type `#{variant}`, `#{type}`"
        end
      end
    end
  end
end
