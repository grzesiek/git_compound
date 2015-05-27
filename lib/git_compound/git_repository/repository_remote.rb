module GitCompound
  module GitRepository
    # Remote git repository implementation
    #
    class RepositoryRemote < RepositoryBase
      def file_contents(file, ref)
        remote_file = RemoteFile.new(@source, ref, file)
        remote_file.contents
      end
    end
  end
end
