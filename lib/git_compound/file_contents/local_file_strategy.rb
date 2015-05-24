module GitCompound
  module FileContents
    # Local file strategy
    #
    class LocalFileStrategy < FileContentsBase
      def initialize(source, file)
        super
        @file = "#{source}/#{file}"
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
        raise FileUnreachable unless reachable?
        raise FileNotFound unless exists?
        File.read(@file)
      end
    end
  end
end
