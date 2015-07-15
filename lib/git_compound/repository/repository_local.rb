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

      def checkout(ref)
        GitCommand.new(:checkout, ref, @source).execute
      end

      def fetch
        GitCommand.new(:fetch, '', @source).execute
        GitCommand.new(:fetch, '--tags', @source).execute
      end

      def merge(mergeable = 'FETCH_HEAD')
        GitCommand.new(:merge, mergeable, @source).execute
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

      def origin_remote
        origin = GitCommand.new(:remote, '-v', @source).execute.match(/origin\t(.*?)\s/)
        origin.captures.first if origin
      end

      def untracked_files?(exclude = nil)
        untracked =
          GitCommand.new('ls-files', '--exclude-standard --others', @source).execute
        return (untracked.length > 0) unless exclude

        untracked = untracked.split("\n")
        untracked.delete_if do |file|
          exclude.include?(file) || exclude.include?(file.split(File::SEPARATOR).first)
        end

        untracked.any?
      end

      def uncommited_changes?
        GitCommand.new('update-index', '-q --refresh', @source).execute
        unstaged = GitCommand.new('diff-files', '--quiet', @source)
        uncommited = GitCommand.new('diff-index', '--cached --quiet HEAD', @source)

        [unstaged, uncommited].any? do |cmd|
          cmd.execute!
          !cmd.valid?
        end
      end

      def unpushed_commits?
        unpushed = GitCommand.new('rev-list', '@{u}..', @source)
        unpushed.execute.length > 0
      end

      def head_sha
        GitCommand.new('rev-parse', 'HEAD', @source).execute
      end
    end
  end
end
