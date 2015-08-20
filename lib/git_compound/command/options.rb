require 'forwardable'

module GitCompound
  module Command
    # Class that parses command arguments
    #
    class Options
      extend Forwardable

      GLOBAL_OPTIONS = [:verbose, :disable_colors]
      delegate [:procedure, :global, :options, :command] => :@parser

      def initialize(argv)
        @parser = Arguments::Parser.new(argv, GLOBAL_OPTIONS)
        set_global_options
      end

      def parse
        [procedure, options]
      end

      def self.verbose=(mode)
        GitCompound::Logger.verbose = mode
      end

      def self.disable_colors=(mode)
        GitCompound::Logger.colors = !mode
      end

      private

      def set_global_options
        self.class.disable_colors = false

        global.each do |option|
          self.class.public_send("#{option}=", true)
        end
      end
    end
  end
end
