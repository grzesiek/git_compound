require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component, 'git_compound/component'
  autoload :Manifest,  'git_compound/manifest'
  autoload :Task,      'git_compound/task'

  # GitCompount Domain Specific Language
  #
  module Dsl
    autoload :Delegator,    'git_compound/dsl/delegator'
    autoload :ComponentDsl, 'git_compound/dsl/component_dsl'
    autoload :ManifestDsl,  'git_compound/dsl/manifest_dsl'
  end

  # Single file contents strategies
  #
  module FileContents
    autoload :FileContentsBase, 'git_compound/file_contents/file_contents_base'
    autoload :GitLocalStrategy, 'git_compound/file_contents/git_local_strategy'
  end
end
