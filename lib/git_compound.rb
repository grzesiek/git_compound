require 'English'
require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component,           'git_compound/component'
  autoload :GitCommand,          'git_compound/git_command'
  autoload :GitRemoteFile,       'git_compound/git_remote_file'
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

  # Remote file contents strategies
  #
  module GitRemoteFileStategy
    autoload :StrategyBase,  'git_compound/git_remote_file_strategy/strategy_base'
  end
end
