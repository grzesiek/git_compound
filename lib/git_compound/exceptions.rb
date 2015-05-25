module GitCompound
  class GitCompoundError < StandardError; end

  class CompoundLoadError < GitCompoundError; end
  class CompoundSyntaxError < GitCompoundError; end
  class FileNotFoundError < GitCompoundError; end
  class FileUnreachableError < GitCompoundError; end
  class RepositoryUnrechableError < GitCompoundError; end
end
