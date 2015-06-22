# Git Compound

Compose your project using git repositories and ruby tasks

## Status

This project is under development, it will be ready within few weeks

## Overview

Create `Compoundfile` or `.gitcompound` manifest:

```ruby
  name :base_component
  
  component :component_1 do
    version '~>1.1'
    source  'git@github.com/user/repository'
    destination 'src/component_1'
  end
  
  component :component_2 do
    sha '5b1d43c08619f958862dded940332c3f91eb35dd'
    source  'git@github.com/user/repository2'
    destination 'src/component_2'
  end
  
  component :some_component_3 do
    branch 'feature/new-feature'
    source '/path/to/component_3/repository'
    destination 'src/vendor/component_3'
  end
  
  task 'add components to gitignore', :each do |component_dir|
    script do
      open('.gitignore', 'a') { |f| f << "#{component_dir}\n" }
  end
```

GitCompound will also process similar manifests found in required components in hierarchical way.

## License

This is free software licensed under MIT license
