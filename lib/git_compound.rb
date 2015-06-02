require 'English'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component,  'git_compound/component'
  autoload :Manifest,   'git_compound/manifest'
  autoload :Repository, 'git_compound/repository'
  autoload :Task,       'git_compound/task'

  # GitCompound Domain Specific Language
  #
  module Dsl
    autoload :ComponentDsl, 'git_compound/dsl/component_dsl'
    autoload :ManifestDsl,  'git_compound/dsl/manifest_dsl'
  end

  # GitCompound component class
  #
  class Component
    autoload :Source,          'git_compound/component/source'
    autoload :Destination,     'git_compound/component/destination'

    module Version
      autoload :AbstractVersion, 'git_compound/component/version/abstract_version'
      autoload :Branch,          'git_compound/component/version/branch'
      autoload :SHA,             'git_compound/component/version/sha'
      autoload :GemVersion,      'git_compound/component/version/gem_version'
    end
  end

  # Repository
  #
  module Repository
    autoload :GitCommand,       'git_compound/repository/git_command'
    autoload :GitRepository,    'git_compound/repository/git_repository'
    autoload :RemoteFile,       'git_compound/repository/remote_file'
    autoload :RepositoryLocal,  'git_compound/repository/repository_local'
    autoload :RepositoryRemote, 'git_compound/repository/repository_remote'

    # Remote file strategy
    #
    class RemoteFile
      autoload :AbstractStrategy,
               'git_compound/repository/remote_file/abstract_strategy'
      autoload :GitArchiveStrategy,
               'git_compound/repository/remote_file/git_archive_strategy'
    end
  end
end
