require 'bundler/setup'
require 'simplecov'
require 'git_compound'
require 'git_helper'

SimpleCov.start
Bundler.require

RSpec.configure do |config|
  config.profile_examples = 2
  config.order = :random
  Kernel.srand config.seed

  config.include GitHelper

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
