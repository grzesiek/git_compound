require 'git_compound/version'
require 'git_compound/exceptions'

# Git Compound module
#
module GitCompound
  autoload :Component, 'git_compound/component'
  autoload :Manifest,  'git_compound/manifest'
  autoload :Task,      'git_compound/task'
  module Dsl
    autoload :Delegator, 'git_compound/dsl/delegator'
    autoload :Manifest,  'git_compound/dsl/manifest'
  end
end
