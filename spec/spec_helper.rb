require 'bundler/setup'
require 'simplecov'
require 'memfs'

SimpleCov.start
Bundler.require

RSpec.configure do |config|
  config.profile_examples = 2
  config.order = :random
  Kernel.srand config.seed

  config.before do
    MemFs.activate!
    # Catch stdout
    @stdout, $stdout = $stdout, StringIO.new
  end

  config.after do
    MemFs.deactivate!
    # Reassign stdout
    $stdout, @stdout = @stdout, nil
  end
end
