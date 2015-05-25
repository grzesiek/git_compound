module GitCompound
  # File loader based on strategies
  #
  class GitFileLoader
    def initialize(source, ref)
      @source = source
      @ref = ref
    end

    def contents(*files)
      strategies.each do |strategy|
        begin
          return load_first_available(files, strategy)
        rescue FileUnreachableError
          next
        end
      end
      raise FileUnreachableError,
            "Couldn't reach manifest after trying #{strategies.count} stategies"
    end

    def strategies
      [FileContents::GitLocalStrategy]
      # Contents::GitArchiveStrategy,
      # Contents::GitHubStrategy]
    end

    private

    def load_first_available(file_names, file_strategy)
      file_names.each do |filename|
        begin
          file = file_strategy.new(@source, @ref, filename)
          return file.contents
        rescue FileNotFoundError
          next
        end
      end
      raise FileNotFoundError,
            "Couldn't find any of #{file_names} files"
    end
  end
end
