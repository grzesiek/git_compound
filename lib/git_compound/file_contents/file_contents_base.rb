module GitCompound
  module FileContents
    # Base interface for FileContents strategies
    #
    class FileContentsBase
      def initialize(source, file)
        @source = source
        @file   = file
      end

      def contents
        raise NotImplementedError
      end

      def reachable?
        raise NotImplementedError
      end

      def exists?
        raise NotImplementedError
      end
    end
  end
end
