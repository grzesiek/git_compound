# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git_compound/version'

Gem::Specification.new do |spec|
  spec.name          = 'git_compound'
  spec.version       = GitCompound::VERSION
  spec.authors       = ['Grzegorz Bizon', 'Tomasz Maczukin']
  spec.email         = ['grzegorz.bizon@ntsn.pl', 'tomasz@maczukin.pl']
  spec.summary       = 'Compose you project using Git repositories and ruby tasks'
  spec.homepage      = 'https://github.com/grzesiek/git_compound'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^spec/) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',   '~> 1.8'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rubocop',   '~> 0.33'
  spec.add_development_dependency 'rspec',     '~> 3.2.0'
  spec.add_development_dependency 'pry',       '~> 0.10.1'
  spec.add_development_dependency 'simplecov', '~> 0.10.0'

  spec.requirements << 'git scm version > 2'
  spec.requirements << 'gnu tar'

  spec.required_ruby_version = '>= 2.2'
end
