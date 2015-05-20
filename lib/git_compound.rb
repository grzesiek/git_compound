require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component, 'git_compound/component'
  autoload :Dsl,       'git_compound/dsl'
  autoload :Manifest,  'git_compound/manifest'
  autoload :Task,      'git_compound/task'
end
