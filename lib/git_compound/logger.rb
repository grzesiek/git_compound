module GitCompound
  # Logger class
  #
  module Logger
    extend self

    def verbose=(value)
      load_debug_messages if value
      @verbose = value && true
    end

    def verbose
      @verbose.nil? ? false : @verbose
    end

    def colors=(value)
      String.disable_colors = !(@colors = value)
    end

    def colors
      @colors.nil? ? true : @colors
    end

    def inline(inline_message)
      print inline_message
      inline_message
    end

    def debug(debug_message)
      log debug_message.cyan
    end

    def info(information_message)
      log information_message
    end

    def warn(warning_message)
      log warning_message.red.bold
    end

    def error(error_message)
      log error_message.on_red.white.bold
    end

    private

    def log(message)
      puts message
      message
    end

    def load_debug_messages
      require 'git_compound/logger/debug/command'
      require 'git_compound/logger/debug/repository'
      require 'git_compound/logger/debug/task'
    end
  end
end
