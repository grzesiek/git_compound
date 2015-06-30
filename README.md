# Git Compound

Compose your project using git repositories and ruby tasks

## Status

Alpha release 0.0.2

## Overview

Create `Compoundfile` or `.gitcompound` manifest:

```ruby
  name :base_component
  
  component :component_1 do
    version '~>1.1'
    source  'git@github.com:/user/repository'
    destination 'src/component_1'
  end
  
  component :component_2 do
    branch 'feature/new-feature'
    source  '/my/component_2/repository'
    destination 'src/component_2'
  end
  
  component :some_component_3 do
    sha '5b1d43c08619f958862dded940332c3f91eb35dd'
    source 'git@github.com:/vendor/component_3'
    destination 'src/vendor/component_3'
  end

  component :some_big_component_4 do
    tag 'fix/tag-name'
    source 'https://github.com/org/big_component', shallow: true
    destination 'src/vendor/component_4'
  end
  
  task 'add components to gitignore', :each do |component_dir|
    script do
      open('.gitignore', 'a') { |f| f << "#{component_dir}\n" }
  end
```

GitCompound will also process similar manifests found in required components in hierarchical way.

## Commands

    gitcompound build [ manifest ]
      -- builds project from manifest

      If manifest is not specified it uses `Compoundfile`
      or `.gitcompound` if present

    gitcompound update [ manifest ]
      -- updates current project

    gitcompound check [ manifest ]
      -- detects circular depenencies, conflicting dependencies
      and checks for name constraints

    gitcompound show [ manifest ]
      -- prints structure of project

    gitcompound help
      -- prints help

## License

This is free software licensed under MIT license
