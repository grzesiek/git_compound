module GitCompound
  # Execute git command
  #
  class GitCommand
    attr_reader :output, :status, :command

    def initialize(cmd, args, workdir = nil)
      @command = "git #{cmd} #{args} 2>&1"
      @workdir = workdir
    end

    def execute!
      path = @workdir ? @workdir : Dir.pwd
      Dir.chdir(path) do
        @output = `#{@command}`
        @status = $?.exitstatus
      end
      @output
    end

    def execute
      execute!
      raise GitCommandError, @output unless valid?
      @output
    end

    def valid?
      @status == 0
    end
  end
end
