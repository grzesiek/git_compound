module GitCompound
  module Repository
    # Remote git repository implementation
    #
    class RepositoryRemote < GitRepository
      def file_contents(file, ref)
        remote_file = RemoteFile.new(@source, ref, file)
        remote_file.contents
      end
    end
  end
end
