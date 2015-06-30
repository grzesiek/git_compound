require 'yaml'

module GitCompound
  # Class that represents lock file
  #
  class Lock
    FILENAME = '.gitcompound.lock'

    def initialize(lock_file = FILENAME)
      @lock_file = lock_file
    end

    def exists?
      File.exist?(@lock_file)
    end

    def <<(component)
    end

    def components
    end
  end
end
