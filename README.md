# Git Compound

Compose your project using git repositories and ruby tasks

## Status

This project is in alpha phase

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
    version '>=2.0'
    source  'git@github.com:/user/repository_2'
    destination 'src/component_2'
  end
  
  component :component_3 do
    branch 'feature/new-feature'
    source  '/my/component_3/repository'
    destination 'src/component_3'
  end
  
  component :some_component_4 do
    sha '5b1d43c08619f958862dded940332c3f91eb35dd'
    source 'git@github.com:/vendor/component_4'
    destination 'src/vendor/component_4'
  end

  task 'add components to gitignore', :each do |component_dir|
    File.open('.gitignore', 'a') { |f| f.write "#{component_dir}\n" }
  end
```

GitCompound will also process similar manifests found in required components in hierarchical way.
Then `gitcompound build`.

## Commands

    gitcompound build [ manifest ]
      -- builds project from manifest (or lockfile if present)

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

## Manifest Domain Specific Language

1.  Use `name` method to specify name of manifest or component that this manifest in included in.

2.  Add dependency to required component using `component` method.

    This method takes two parameters -- name of component (as symbol) and implicit or explicit block.

    Beware that `GitCompound` checks for component name constraints, so if you require component 
    with name `:component_1`, and this component has Compoundfile manifest inside that declares 
    it's name as something else than `:component_1` -- `GitCompound` will raise exception.

3.  Components can use follow version strategies:

    *   `version` -- Rubygems-like version strategy
        
        This strategy uses Git tags to determine available component versions.
        If tag matches `/^v?#{Gem::Version::VERSION_PATTERN}$/` then it is considered to 
        be version tag and therefore it can be used with Rubygems syntax 
        (like pessimistic version constraint operator)
      
    *   `tag` -- use component sources specified by tag
    *   `branch` -- use HEAD of given branch
    *   `sha` -- use explicitly set commit SHA

4.  Provide path to repository using `source` method in manifest DSL.

    This will be used to clone repository into destination directory.

    This can take `:shallow` parameter, but it is not recommended to use it.
    It can be helpful when required component is big and you need to build your project
    only once, but it causes issues with update. Use it with caution !
 

5.  Use `destination` method to specify path where component will be cloned into.

    This should be relative path in most cases. 

    lative path is always relative to parent component directory. So if you define 
    `component_1` with destination path `component_1/`, and this component will
    depend on `component_2` with destination path set to `src/component_2`, you will
    end with `./component_1/src/component_2` directory after building components.

    When this path is absolute -- it will be always relative to `Dir.pwd` where 
    you invoke `gitcompound *` commands. So if you have `component_1` with destination path
    set to `/component_1` and `component_1` has manifest that depends on `component_2` with
    destination path set to `/component_2`, then `GitCompound` will create two separate
    directories in `Dir.pwd`: `./component_1` and `./component_2`.

    Use absolute paths with caution as it affects how parent projects are being built.
    Ceraintly components that are libraries should not use it at all. If component is project --
    it can take benefit from using absolute paths in component destination.

6.  Running tasks

    It is possible to use `task` method to define new task. `task` method takes 2 or 3 arguments.
    First one is task name (symbol), second one is optional task type and define how task and 
    in which context task will be executed, third one is block that will be excuted.

    Currently there are three task types:

    *   `:manifest` type (this is default, and optional) -- run task for current manifest
        
        Manifest task will be executed only once, in context of current manifest this task is
        defined in. Example:

        ```ruby
        task :print_manifest_name do |dir, manifest|
          puts "Current manifest name is #{manifest.name} and dir is: #{dir}"
        end
        ```      
  
    *   `:each` type -- run task for each component defined in current manifest
      
        This executes task for all components that are explicitly defined in current manifest.
        Example:

        ```ruby
        task :print_component_name, :each do |dir, component|
          puts "Current component name: #{component.name}"
          puts "Current component source: #{component.origin}
          puts "Current component destination: #{component.destination_path}

          puts "Component directory: #{dir}"
        end
        ```

        Note that `dir` here is the same as `component.destination_path`
        
    *   `:all` type -- run task for all child components of this manifest

        Task for `:all` components will be executed in context of every component
        this manifest is parent of.

        It will be executed for all components defined in manifest itself and for all 
        components that are included in child manifests (obviously child manifests are 
        manifests included in components defined in parent manifest)

        Example:

        ```ruby
        task :print_all_component_names, :all do |dir, component|
          puts "Component #{component.name} destination dir: #{dir}"
        end
        ```
 
7.  Accessing manifests -- fast

    `GitCompound` tries to be as fast as possible. To achieve this it tries to access
    manifest of required component without cloning it first. Is uses different strategies to
    achieve this. Currently only two strategies are available:
    
    *   `GitArchiveStrategy` -- it uses `git archive` command to access single file in remote
        repository
    *   `GithubStrategy` -- it uses http request to `raw.githubusercontent.com` to access manifest

    It is possible to create new strategies by implementing new strategy base on
    `GitCompound::Repository::RemoteFile::RemoteFileStrategy` abstraction.


## License

This is free software licensed under MIT license
