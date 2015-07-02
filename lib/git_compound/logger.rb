module GitCompound
  # Logger class
  #
  module Logger
    extend self

    def info(information_message)
      puts information_message
      information_message
    end

    def inline(inline_message)
      print inline_message
      inline_message
    end

    def warn(warning_message)
      puts "[!] #{warning_message}"
      warning_message
    end

    def error(error_message)
      puts "[-] #{error_message}"
      error_message
    end
  end
end
