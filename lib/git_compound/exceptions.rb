module GitCompound
  class GitCompoundError < StandardError; end

  class CompoundLoadError < GitCompoundError; end
  class CompoundSyntaxError < GitCompoundError; end
  class FileNotFound < GitCompoundError; end
  class FileUnreachable < GitCompoundError; end
end
