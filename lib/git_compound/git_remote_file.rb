module GitCompound
  # Remote file loader based on strategies
  #
  class GitRemoteFile
    def initialize(source, ref)
      @source = source
      @ref = ref
    end

    def contents(file)
      strategies.each do |strategy|
        begin
          return strategy.new(@source, @ref, file).contents
        rescue FileUnreachableError
          next
        end
      end
      raise FileUnreachableError,
            "Couldn't reach manifest after trying #{@strategies.count} stategies"
    end

    def strategies
      []
      # GitArchiveStrategy,
      # GitHubStrategy]
    end
  end
end
