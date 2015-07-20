require 'simplecov'
SimpleCov.start { add_filter '/spec' }

require 'bundler/setup'
Bundler.require

require 'git_helper'
require 'git_test_env_builder'

RSpec.configure do |config|
  config.profile_examples = 2
  config.order = :random
  Kernel.srand config.seed

  config.include GitHelper
  config.include GitTestEnvBuilder

  config.before do
    # Catch stdout
    # @stdout, $stdout = $stdout, StringIO.new
    # @stderr, $stderr = $stderr, StringIO.new
    GitCompound::Command::Options.verbose = true
    GitCompound::Command::Options.disable_colors = true
  end

  config.around do |example|
    @gem_dir = Dir.pwd
    Dir.mktmpdir %w(gitcompound_ _test) do |dir|
      @dir = dir
      Dir.chdir(dir) { example.run }
    end
  end

  config.after do
    # Reassign stdout
    # $stdout, @stdout = @stdout, nil
    # $stderr, @stderr = @stderr, nil
  end
end
