require 'git_compound/exceptions'
require 'git_compound/version'

# Git Compound module
#
module GitCompound
  autoload :Builder,    'git_compound/builder'
  autoload :Command,    'git_compound/command'
  autoload :Component,  'git_compound/component'
  autoload :Lock,       'git_compound/lock'
  autoload :Logger,     'git_compound/logger'
  autoload :Manifest,   'git_compound/manifest'
  autoload :Node,       'git_compound/node'
  autoload :Repository, 'git_compound/repository'
  autoload :Task,       'git_compound/task'

  # GitCompound Domain Specific Language
  #
  module DSL
    autoload :ComponentDSL, 'git_compound/dsl/component_dsl'
    autoload :ManifestDSL,  'git_compound/dsl/manifest_dsl'
  end

  # GitCompound component class
  #
  class Component
    autoload :Source,          'git_compound/component/source'
    autoload :Destination,     'git_compound/component/destination'

    # Possible component versions
    #
    module Version
      autoload :Branch,          'git_compound/component/version/branch'
      autoload :GemVersion,      'git_compound/component/version/gem_version'
      autoload :SHA,             'git_compound/component/version/sha'
      autoload :Tag,             'git_compound/component/version/tag'
      autoload :VersionStrategy, 'git_compound/component/version/version_strategy'
    end
  end

  # GitCompound Command
  #
  module Command
    autoload :Options, 'git_compound/command/options'

    # Command Procedure
    #
    module Procedure
      autoload :Procedure, 'git_compound/command/procedure/procedure'
      autoload :Check,     'git_compound/command/procedure/check'
      autoload :Help,      'git_compound/command/procedure/help'
      autoload :Show,      'git_compound/command/procedure/show'
      autoload :Tasks,     'git_compound/command/procedure/tasks'
      autoload :Update,    'git_compound/command/procedure/update'

      # Procedure Element
      #
      module Element
        autoload :Manifest,     'git_compound/command/procedure/element/manifest'
        autoload :Lock,         'git_compound/command/procedure/element/lock'
        autoload :Subprocedure, 'git_compound/command/procedure/element/subprocedure'
      end
    end
  end

  # GitCompound Logger
  #
  module Logger
    autoload :Colors,   'git_compound/logger/colors'
    autoload :Debugger, 'git_compound/logger/debugger'
    require 'git_compound/logger/core_ext/string'
  end

  # Task module
  #
  module Task
    autoload :Task,       'git_compound/task/task'
    autoload :TaskAll,    'git_compound/task/task_all'
    autoload :TaskEach,   'git_compound/task/task_each'
    autoload :TaskSingle, 'git_compound/task/task_single'
  end

  # Repository
  #
  module Repository
    autoload :GitCommand,       'git_compound/repository/git_command'
    autoload :GitRepository,    'git_compound/repository/git_repository'
    autoload :GitVersion,       'git_compound/repository/git_version'
    autoload :RemoteFile,       'git_compound/repository/remote_file'
    autoload :RepositoryLocal,  'git_compound/repository/repository_local'
    autoload :RepositoryRemote, 'git_compound/repository/repository_remote'

    # Remote file strategy
    #
    class RemoteFile
      autoload :GitArchiveStrategy,
               'git_compound/repository/remote_file/git_archive_strategy'
      autoload :GithubStrategy,
               'git_compound/repository/remote_file/github_strategy'
      autoload :RemoteFileStrategy,
               'git_compound/repository/remote_file/remote_file_strategy'
    end
  end

  # Workers
  #
  module Worker
    autoload :CircularDependencyChecker,
             'git_compound/worker/circular_dependency_checker'
    autoload :ComponentBuilder,
             'git_compound/worker/component_builder'
    autoload :ComponentDispatcher,
             'git_compound/worker/component_dispatcher'
    autoload :ComponentUpdater,
             'git_compound/worker/component_updater'
    autoload :ComponentReplacer,
             'git_compound/worker/component_replacer'
    autoload :ComponentsCollector,
             'git_compound/worker/components_collector'
    autoload :ConflictingDependencyChecker,
             'git_compound/worker/conflicting_dependency_checker'
    autoload :LocalChangesGuard,
             'git_compound/worker/local_changes_guard'
    autoload :NameConstraintChecker,
             'git_compound/worker/name_constraint_checker'
    autoload :PrettyPrint, 'git_compound/worker/pretty_print'
    autoload :TaskRunner,  'git_compound/worker/task_runner'
    autoload :Worker,      'git_compound/worker/worker'
  end

  extend Command
end
