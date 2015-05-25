module GitCompound
  module FileContents
    # Base interface for FileContents strategies
    #
    class GitFileContents
      def initialize(source, ref, file)
        @source = source
        @ref    = ref
        @file   = file
        raise FileUnreachableError unless reachable?
        raise FileNotFoundError unless exists?
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
