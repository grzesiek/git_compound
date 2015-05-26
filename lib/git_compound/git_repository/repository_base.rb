module GitCompound
  module GitRepository
    # Git repository base class
    #
    class RepositoryBase
      def initialize(source)
        @source = source
      end

      def refs
        refs = GitCommand.new('ls-remote', @source).execute
        refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
      rescue GitCommandError
        raise RepositoryUnrechableError, 'Could not reach repository'
      end

      def has_ref?(ref)
        matching = refs.select do |refs_array|
          refs_array.include?(ref.to_s)
        end
        matching.any?
      end

      def file_exists?(file, ref)
        raise NotImplementedError
      end

      def file_contents(file, ref)
        raise NotImplementedError
      end
    end
  end
end
