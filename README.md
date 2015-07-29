# GitCompound

Compose your project using git repositories and Ruby tasks.

GitCompound combines features of Git submodules and common dependency managers like Bundler or Composer.

## Overview

Create `Compoundfile` or `.gitcompound` manifest:

```ruby
  name :base_component

  component :vendor_1 do
    version '~>1.1'
    source  'git@github.com:/user/repository'
    destination 'src/component_1'
  end

  component :second_component do
    version '>=2.0'
    source  'git@github.com:/user/repository_2'
    destination 'src/component_2'
  end

  component :my_component do
    branch 'feature/new-feature'
    source  '/my/component_3/repository'
    destination 'src/component_3'
  end

  task 'print details', :each do |_path, component|
    puts "Component `#{component.name}` installed in #{component.path}"
  end
```

Then run `gitcompound build`.

GitCompound will also process manifests found in dependencies.



## Core features 

GitCompound is more a distributed packaging system (dependency manager) than alternative to Git submodules,
however it has common features of both Git submodules and dependency managers like Bundler or Composer.

`GitCompound` makes sure your project composition is the same on all machines,
but you can have different composition depending on manifest you are using.

It has been created with Docker compatiblity in mind.

Core features:

*   `GitCompound` introduces Domain Specific Language desgined for writing manifests.

*   It is possible to create multiple manifest files (`Compoundfile`, `.gitcompound` or something else)
    and build them when necessary.

*   Manifests can declare dependencies on different versions of components using different version strategies
    (Rubygems-like version, tag, branch or explicit SHA).

*   Manifests will be processed in hierarchical way. Manifest that `gitcompound` command is run against
    is root manifest. `GitCompound` processes all subsequent manifests found in dependencies using depth-first
    search of dependency graph.

*   Root manifest and manifests of each subsequent component can declare Ruby tasks that will be executed
    when component is built or updated.

*   It is possible to install dependencies in root directory (`Dir.pwd` where `gitcompound` command is invoked).
    Each subsequent component can install their dependencies into root directory (see overview for **destination** DSL method).

*   Build process creates lockfile in `.gitcompound.lock`. It locks components on specific commit SHAs.
    It is then possible to build components directly, depending on versions (SHAs) from lockfile.
    When lockfile is present if will be used each time `build` command is invoked.

*   It is possible to use repositories, that has been used as dependencies, for development (like in Git submodules).


## Commands

### build

`gitcompound build [manifest]` -- builds project from manifest or lockfile

If manifest is not supplied, it uses `Compoundfile` or `.gitcompound`

### update

`gitcompound update [manifest]` -- updates project and lockfile

### check

`gitcompound check [manifest]` -- checks for circular dependencies, conflicting dependencies
and name constraints

### show

`gitcompound show [manifest]` -- prints project structure

### help

`gitcompound help` -- prints help message

## Global options

1.  `--verbose` -- turns debug mode on
2.  `--disable-colors` -- disables ANSI colors in output

## Details

1.  Use `name` method to specify **name** of manifest or component that this manifest is included in.

2.  Add dependency to required **component** using `component` method.

    This method takes two parameters -- name of component (as symbol) and implicit or explicit block.

    Beware that `GitCompound` checks name constraints, so if you rely on component
    with name `:component_1`, and this component has `Compoundfile` inside that declares 
    it's name as something else than `:component_1` -- `GitCompound` will raise exception.

3.  Components can use following **version strategies**:

    *   `version` -- Rubygems-like **version** strategy
        
        This strategy uses Git tags to determine available component versions.
        If tag matches `/^v?#{Gem::Version::VERSION_PATTERN}$/` then it is considered to 
        be version tag and therefore it can be used with Rubygems syntax 
        (like pessimistic version constraint operator)

    *   `tag` -- use component sources specified by **tag**

    *   `branch` -- use HEAD of given **branch**

    *   `sha` -- use explicitly set commit **SHA**

4.  Provide path to **source** repository using `source` method of manifest domain specific language.

    It will be used as source to clone repository into destination directory.

    This can take `:shallow` parameter. When `:shallow` is set, shallow clone will be 
    performed (`--branch #{ref} --depth 1`):

    ```ruby
    component :bootstrap do
      version '~>3.3.5'
      source 'git@github.com:twbs/bootstrap', :shallow
      destination '/vendor/bootstrap
    end
    ```

    However using it is not recommended at all.

    It can be helpful when required component is big and you need to build your project
    only once, but it will cause issues with update. You will not be able to update it properly.
    Use it with caution !


5.  Use `destination` method to specify **destination** path where component will be cloned into.

    This should be relative path in most cases.

    Relative path is always relative to parent component directory. So if you define 
    `component_1` with destination path `component_1/`, and this component will
    depend on `component_2` with destination path set to `src/component_2`, you will
    end with `./component_1/src/component_2` directory after building components.

    When path is absolute -- it will be always relative to `Dir.pwd` where
    you invoke `gitcompound *` commands. So if you have `component_1` with destination path
    set to `/component_1` and `component_1` which has manifest that depends on `component_2` with
    destination path set to `/component_2`, then `GitCompound` will create two separate
    directories in `Dir.pwd`: `./component_1` and `./component_2`.

    Use absolute paths with caution as it affects how parent projects will be built.
    Ceraintly components that are libraries should not use it at all. If component is project --
    it can take benefit from using absolute paths in component destination.

6.  Running tasks

    It is possible to use `task` method to define new **task**. `task` method takes 2 or 3 arguments.
    First one is task name (symbol). Second one is optional task type that define how, and 
    in which context, task will be executed. Third one is block that will be excuted.

    Currently there are three task types:

    *   `:manifest` type (this is default) -- run task in context of current manifest

        Task will be executed only once, in context of current manifest this task is
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

        Note that `dir` here is the same as `component.destination_path`.

    *   `:all` type -- run task for all child components of this manifest

        Task for `:all` components will be executed in context of every component
        this manifest is parent of.

        It will be executed for all components defined in manifest itself and for all
        components that are included in child manifests (obviously child manifests are
        manifests included in components defined in parent manifest).

        Example:

        ```ruby
        task :print_all_component_names, :all do |dir, component|
          puts "Component #{component.name} destination dir: #{dir}"
        end
        ```

    By default `GitCompound` executes only tasks defined in root manifest.

    This is default behaviour dictated by security reasons. Since all tasks (also those defined 
    in child component) are visited in reverse order it is possible to execute them too.

    If you know what you are doing and it is your conscious decision to run all tasks in project
    pass `--allow-nested-subtasks` options to `build` or `update` command.

    It can be beneficial approach, but it has to be done with caution.

## Other concepts

1.  Accessing manifests

    `GitCompound` tries to be as fast as possible. To achieve this it tries to access
    manifest of required component without cloning it first. Is uses different strategies to
    achieve this. Currently only two strategies are available:
    
    *   `GitArchiveStrategy` -- it uses `git archive` command to access single file in remote
        repository,
    *   `GithubStrategy` -- it uses http request to `raw.githubusercontent.com` to access 
        manifest file at GitHub.

    It is possible to create new strategies by implementing new strategy base on
    `GitCompound::Repository::RemoteFile::RemoteFileStrategy` abstraction.

2.  Using lockfile (`.gitcompound.lock`)

    If lockfile is present, `gitcompound build` command will ignore manifest, and build
    components, with versions locked in commit SHA. You can always be sure that your
    environment will be unchange when building from lockfile.

3.  Building manifest

    Behavior of `build` command depends on whether lockfile exists or not.

    *   When lockfile does not exist -- components will be built using versions stored in manifest.

        Then lockfile `.gitcompound.lock` will be created, locking each component on specific commit SHA
        that component has been checkout on during build process.

    *   If lockfile is present it will be used as source for update process (see "Updating manifest" below)

4.  Updating manifest

    When using `gitcompound update` command each subsequent component will be either
    built, updated or replaced:

    *   built (cloned) -- if destination directory does not exist
    *   updated (fetch & checkout) -- if component exists, matches origin and existing SHA != new SHA
    *   replaced (remove & clone) -- if component exists but doesn't match origin remote

    When invoking update process via `gitcompound update` command, versions specified in manifest file
    will be use.

## Roadmap

Take a look at issues at GitHub.

## License

This is free software licensed under MIT license
