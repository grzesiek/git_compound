module GitCompound
  module Repository
    # Local git repository implementation
    #
    class RepositoryLocal < GitRepository
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

      # def file_reachable?(file, ref)
      #   cmd = GitCommand.new(:show, "#{ref}:#{file}", @source)
      #   cmd.execute!
      #   !(cmd.output =~ /does not exist in/)
      # end

      def file_contents(file, ref)
        raise FileNotFoundError unless file_exists?(file, ref)
        # raise FileUnreachableError unless file_reachable?(file, ref)
        GitCommand.new(:show, "#{ref}:#{file}", @source).execute
      end
    end
  end
end
