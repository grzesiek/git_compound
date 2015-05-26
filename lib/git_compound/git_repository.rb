module GitCompound
  # Git repository implementation
  #
  class GitRepository
    def initialize(remote)
      @remote = remote
    end

    def refs
      refs = GitCommand.new('ls-remote', @remote).execute
      refs.scan(%r{^(\b[0-9a-f]{5,40}\b)\srefs\/(heads|tags)\/(.+)})
    rescue GitCommandError
      raise RepositoryUnrechableError, 'Could not read from remote repository'
    end

    def has_ref?(ref)
      matching = refs.select do |refs_array|
        refs_array.include?(ref.to_s)
      end
      matching.any?
    end
  end
end
