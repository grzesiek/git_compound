module GitCompound
  module FileContents
    # Local Git repository strategy
    #
    class GitLocalStrategy < GitFileContents
      def initialize(source, ref, file)
        super
        @source.sub!(%r{^file://}, '')
        @file = "#{source}/#{file}"
        raise FileUnreachable unless reachable?
        raise FileNotFound unless exists?
      end

      def reachable?
        tests = []
        tests << @source.start_with?('/')
        tests << File.directory?(@source)
        tests.all?
      end

      def exists?
        reachable? && File.exist?(@file)
      end

      def contents
        File.read(@file)
      end
    end
  end
end
