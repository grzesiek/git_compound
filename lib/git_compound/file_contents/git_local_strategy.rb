module GitCompound
  module FileContents
    # Local Git repository strategy
    #
    class GitLocalStrategy < GitFileContents
      def initialize(source, ref, file)
        super
        @repository = GitRepository::RepositoryLocal.new(@source)
      end

      def reachable?
        return false unless GitRepository.local?(@source)
        return false unless @repository.ref_exists?(@ref)
        true
      end

      def exists?
        raise FileUnreachableError unless reachable?
        @repository.file_exists?(@file, @ref)
      end

      def contents
        raise FileNotFoundError unless exists?
        @repository.file_contents(@file, @ref)
      end
    end
  end
end
