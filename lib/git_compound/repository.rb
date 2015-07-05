module GitCompound
  # Git repositories module, also repository factory
  #
  module Repository
    extend self

    def factory(source)
      if local?(source)
        RepositoryLocal.new(source)
      else
        RepositoryRemote.new(remote = source) # rubocop:disable Lint/UselessAssignment
      end
    end

    def local?(source)
      source.match(%r{(^\/|file:\/\/).*})
    end
  end
end
