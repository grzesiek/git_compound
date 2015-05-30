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
  end

  config.around do |example|
    Dir.mktmpdir %w(gitcompound_ _test) do |dir|
      @dir = dir
      Dir.chdir(dir) { example.run }
    end
  end

  config.after do
    # Reassign stdout
    # $stdout, @stdout = @stdout, nil
  end
end
