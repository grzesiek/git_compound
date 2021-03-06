require 'English'

module GitCompound
  module Repository
    # Execute git command
    #
    class GitCommand
      attr_reader :output, :status, :command

      def initialize(cmd, args, workdir = nil)
        @command = "git #{cmd} #{args}"
        @workdir = workdir
      end

      def execute!
        path = @workdir ? @workdir : Dir.pwd
        Dir.chdir(path) { @output = `(#{@command}) 2>&1` }
        @status = $CHILD_STATUS.exitstatus
        @output.sub!(/\n\Z/, '')
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
end
