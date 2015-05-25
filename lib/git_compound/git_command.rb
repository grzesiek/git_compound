module GitCompound
  class GitCommand
    attr_reader :output, :status

    def initialize(command)
      @command = command
    end

    def execute!
      @output = `#{@command} 2>&1`
      @status = $?.exitstatus
      @output
    end

    def execute
      execute!
      raise GitCommandError, @output unless valid?
      @output
    end

    def execute_in(path)
      Dir.chdir(path) do
        execute
      end
      @output
    end

    def valid?
      @status == 0
    end
  end
end
