# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_compose/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_compose'
  spec.version       = GitCompose::VERSION
  spec.authors       = ['Grzegorz Bizon']
  spec.email         = ['grzegorz.bizon@ntsn.pl']

  spec.summary       = 'Compose you projects using git repositories and tasks'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^spec/) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # rubocop:disable Style/SingleSpaceBeforeFirstArg
  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependecy  'rubocop', '~> 0.31.0'
  spec.add_development_dependecy  'rspec',   '~> 3.2.0'
  spec.add_development_dependecy  'pry',     '~> 0.10.1'
  spec.requirements               'git scm'
  # rubocop:enable Style/SingleSpaceBeforeFirstArg
end
