require 'English'
require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component,           'git_compound/component'
  autoload :GitCommand,          'git_compound/git_command'
  autoload :GitRepository,       'git_compound/git_repository'
  autoload :Manifest,            'git_compound/manifest'
  autoload :Task,                'git_compound/task'

  # GitCompount Domain Specific Language
  #
  module Dsl
    autoload :ComponentDsl, 'git_compound/dsl/component_dsl'
    autoload :ManifestDsl,  'git_compound/dsl/manifest_dsl'
  end

  # Git repositories
  #
  module GitRepository
    autoload :RepositoryBase,   'git_compound/git_repository/repository_base'
    autoload :RepositoryLocal,  'git_compound/git_repository/repository_local'
    autoload :RepositoryRemote, 'git_compound/git_repository/repository_remote'
    autoload :RemoteFile,       'git_compound/git_repository/remote_file'

    # Git remote file strategy
    #
    module RemoteFileStrategy
      autoload :StrategyBase,
               'git_compound/git_repository/remote_file_strategy/strategy_base'
      autoload :GitArchiveStrategy,
               'git_compound/git_repository/remote_file_strategy/git_archive_strategy'
    end
  end
end
