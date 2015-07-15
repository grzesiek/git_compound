module GitCompound
  # Logger class
  #
  module Logger
    extend self

    def verbose=(value)
      @verbose = value && true
    end

    def verbose
      @verbose ||= false
    end

    def inline(inline_message)
      print inline_message
      inline_message
    end

    def debug(debug_message, *params)
      log(debug_message.cyan, *params) if verbose
    end

    def info(information_message, *params)
      log(information_message, *params)
    end

    def warn(warning_message, *params)
      log(warning_message.red.bold, *params)
    end

    def error(error_message, *params)
      log(error_message.on_red.white.bold, *params)
    end

    private

    def log(message, *params)
      puts message unless params.include?(:quiet)
      message
    end
  end
end
