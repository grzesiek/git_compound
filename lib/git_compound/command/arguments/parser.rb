module GitCompound
  module Command
    module Arguments
      # Class responsible for parsing ARGV for given procedure
      #
      class Parser
        def initialize(argv, global)
          @global    = global
          @args      = arguments(argv)
        end

        def procedure
          Command.const_get("Procedure::#{command.capitalize}")
        rescue
          Procedure::Help
        end

        def command
          @args.find { |arg| arg.is_a?(String) }
        end

        def options
          given, expected = procedure_parameters
          options = { args: [] }

          given.each_cons(3) do |arg_prev, arg, arg_next|
            case
            when expected_parameter_boolean?(expected, arg)
              options.merge!(arg => true)
            when expected_parameter_type_valid?(expected, arg)
              options.merge!(arg => arg_next)
            when unexpected_parameter_string?(expected, arg, arg_next)
              options.merge!(arg => arg_next)
            when unexpected_argument?(expected, arg_prev, arg)
              options[:args] << arg
            end
          end

          options
        end

        def global
          @args & @global
        end

        private

        def arguments(argv)
          argv.map do |arg|
            arg.start_with?('--') ? arg.sub(/^--/, '').tr('-', '_').to_sym : arg
          end
        end

        def procedure_parameters
          given    = [nil] + (@args - @global - [command]) + [nil]
          expected = procedure.options
          [given, expected]
        end

        def expected_parameter_boolean?(expected, parameter)
          expected.include?(parameter) &&
            expected[parameter][:type] == Procedure::Element::Parameter::Boolean
        end

        def expected_parameter_type_valid?(expected, parameter)
          expected.include?(parameter) &&
            arg_next.is_a?(expected[parameter][:type])
        end

        def unexpected_parameter_string?(expected, parameter, value)
          !expected.include?(parameter) &&
            parameter.is_a?(Symbol) && value.is_a?(String)
        end

        def unexpected_argument?(expected, arg_prev, argument)
          (expected_parameter_boolean?(expected, arg_prev) || !arg_prev.is_a?(Symbol)) &&
            argument.is_a?(String)
        end
      end
    end
  end
end
