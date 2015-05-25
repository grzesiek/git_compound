module GitCompound
  module FileContents
    # Local Git repository strategy
    #
    class GitLocalStrategy < GitFileContents
      def initialize(source, ref, file)
        source.sub!(%r{^file://}, '')
        file = "#{source}/#{file}"
        super
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
