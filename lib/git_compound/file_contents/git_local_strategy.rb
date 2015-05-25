module GitCompound
  module FileContents
    # Local Git repository strategy
    #
    class GitLocalStrategy < FileContentsBase
      def initialize(source, file)
        super
        @file = "#{source}/#{file}"
        raise FileUnreachable unless reachable?
        raise FileNotFound unless exists?
      end

      def reachable?
        tests = []
        tests << (@source.start_with?('/') || @source.start_with?('file://'))
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
