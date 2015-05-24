require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new('spec')
RuboCop::RakeTask.new

task :test do
  Rake::Task['spec'].invoke
  Rake::Task['rubocop'].invoke
end

task default: :test
