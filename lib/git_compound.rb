require 'English'
require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component,           'git_compound/component'
  autoload :GitCommand,          'git_compound/git_command'
  autoload :GitFileLoader,       'git_compound/git_file_loader'
  autoload :GitRepository,       'git_compound/git_repository'
  autoload :Manifest,            'git_compound/manifest'
  autoload :Task,                'git_compound/task'

  # GitCompount Domain Specific Language
  #
  module Dsl
    autoload :ComponentDsl, 'git_compound/dsl/component_dsl'
    autoload :Delegator,    'git_compound/dsl/delegator'
    autoload :ManifestDsl,  'git_compound/dsl/manifest_dsl'
  end

  # Git repositories
  module GitRepository
    autoload :RepositoryBase,   'git_compound/git_repository/repository_base'
    autoload :RepositoryLocal,  'git_compound/git_repository/repository_local'
    autoload :RepositoryRemote, 'git_compound/git_repository/repository_remote'
  end

  # Single file contents strategies
  #
  module FileContents
    autoload :GitFileContents,  'git_compound/file_contents/git_file_contents'
    autoload :GitLocalStrategy, 'git_compound/file_contents/git_local_strategy'
  end
end
