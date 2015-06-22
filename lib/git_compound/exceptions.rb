module GitCompound
  class GitCompoundError < StandardError; end

  class CompoundLoadError < GitCompoundError; end
  class CompoundSyntaxError < GitCompoundError; end
  class FileNotFoundError < GitCompoundError; end
  class FileUnreachableError < GitCompoundError; end
  class RepositoryUnreachableError < GitCompoundError; end
  class GitCommandError < GitCompoundError; end
  class LocalRepositoryNotFoundError < GitCompoundError; end
  class DependencyError < GitCompoundError; end
  class CircularDependencyError < GitCompoundError; end
  class ConflictingDependencyError < GitCompoundError; end
  class NameConstraintError < GitCompoundError; end
end
