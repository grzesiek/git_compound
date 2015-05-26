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
          verify_ref = GitCommand.new('show-ref', "-q #{@ref}", @source)
          verify_ref.execute!
          tests << verify_ref.valid?
        end
        tests.all?
      end

      def exists?
        raise FileUnreachableError unless reachable?
        GitCommand.new(:show, "#{@ref}:#{@file}", @source).execute
        true
      rescue GitCommandError
        false
      end

      def contents
        raise FileUnreachableError unless reachable?
        raise FileNotFoundError unless exists?
        GitCommand.new(:show, "#{@ref}:#{@file}", @source).execute
      end

      private

    end
  end
end
