module GitCompound
  module GitRepository
    # Local git repository implementation
    #
    class RepositoryLocal < RepositoryBase
      def initialize(source)
        super
        raise RepositoryUnreachableError unless
          File.directory?("#{@source}/.git")
      end

      def file_exists?(file, ref)
        cmd = GitCommand.new(:show, "#{ref}:#{file}", @source)
        cmd.execute!
        cmd.valid?
      end

      def file_contents(file, ref)
        raise FileNotFoundError unless file_exists?(file, ref)
        GitCommand.new(:show, "#{ref}:#{file}", @source).execute
      end
    end
  end
end
