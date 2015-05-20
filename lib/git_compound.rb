require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Manifest, 'git_compound/manifest'
  autoload :Dsl,      'git_compound/dsl'
end
