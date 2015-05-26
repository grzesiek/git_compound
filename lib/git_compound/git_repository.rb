module GitCompound
  # Git repositories module, also repository factory
  #
  module GitRepository
    def self.factory(source)
      if local?(source)
        RepositoryLocal.new(source)
      else
        RepositoryRemote.new(remote = source) # rubocop:disable Lint/UselessAssignment
      end
    end

    def self.local?(source)
      tests = [source.match(%r{(^\/|file:\/\/).*})]
      tests << File.directory?(source)
      tests.all?
    end
  end
end
