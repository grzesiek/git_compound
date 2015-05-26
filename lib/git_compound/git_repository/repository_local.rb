module GitCompound
  module GitRepository
    # Local git repository implementation
    #
    class RepositoryLocal < RepositoryBase
      def file_exists?(file, ref)
        cmd = GitCommand.new(:show, "#{ref}:#{file}", @source)
        cmd.execute!
        cmd.valid?
      end

      def file_contents(file, ref)
        contents = GitCommand.new(:show, "#{ref}:#{file}", @source).execute
      rescue GitCommandError
        raise FileNotFoundError
      end
    end
  end
end
