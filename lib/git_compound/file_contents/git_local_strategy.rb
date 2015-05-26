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
        tests << GitRepository.new(@source).has_ref?(@ref)
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
