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

      def clone(destination, options = nil)
        # Prefer ^file:/// instead of ^/ as latter does not work with --depth
        source = @source.sub(%r{^\/}, 'file:///')
        super(destination, options, source)
      end

      def file_exists?(file, ref)
        cmd = GitCommand.new(:show, "#{ref}:#{file}", @source)
        cmd.execute!
        cmd.valid?
      end

      def checkout(ref)
        GitCommand.new(:checkout, ref, @source).execute
      end

      def file_contents(file, ref)
        raise FileNotFoundError unless file_exists?(file, ref)
        GitCommand.new(:show, "#{ref}:#{file}", @source).execute
      end
    end
  end
end
