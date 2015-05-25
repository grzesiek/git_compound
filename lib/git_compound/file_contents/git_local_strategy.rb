module GitCompound
  module FileContents
    # Local Git repository strategy
    #
    class GitLocalStrategy < GitFileContents
      def initialize(source, ref, file)
        source.sub!(%r{^file://}, '')
        super
      end

      def reachable?
        tests = []
        tests << @source.start_with?('/')
        tests << File.directory?(@source)
        if tests.all?
          verify_ref = GitCommand.new("git show-ref -q #{@ref}")
          verify_ref.execute_in(@source)
          tests << verify_ref.valid?
        end
        tests.all?
      end

      def exists?
        raise FileUnreachableError unless reachable?
        GitCommand.new("git show #{@ref}:#{@file}").execute_in(@source)
        true
      rescue GitCommandError
        false
      end

      def contents
        raise FileUnreachableError unless reachable?
        raise FileNotFoundError unless exists?
        GitCommand.new("git show #{@ref}:#{@file}").execute_in(@source)
      end

      private

    end
  end
end
