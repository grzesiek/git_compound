module GitCompound
  # File loader based on strategies
  #
  class GitFileLoader
    def initialize(source, ref, strategies)
      @source = source
      @ref = ref
      @strategies = strategies
    end

    def contents(file)
      @strategies.each do |strategy|
        begin
          return strategy.new(@source, @ref, file).contents
        rescue FileUnreachableError
          next
        end
      end
      raise FileUnreachableError,
            "Couldn't reach manifest after trying #{@strategies.count} stategies"
    end

    def self.strategies_available
      [FileContents::GitLocalStrategy]
      # FileContents::GitArchiveStrategy,
      # FileContents::GitHubStrategy]
    end
  end
end
