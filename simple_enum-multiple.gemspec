# Frozen-String-Literal: true
# Encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_enum/multiple/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_enum-multiple'
  spec.version       = SimpleEnum::Multiple::VERSION
  spec.email         = ['bbtfrr@gmail.com']
  spec.authors       = ['Theo Li']

  spec.summary       = 'Multi-select enum support for SimpleEnum.'
  spec.description   = 'SimpleEnum::Multiple is multi-select extension for SimpleEnum.'
  spec.homepage      = 'https://github.com/bbtfr/simple_enum-multiple'
  spec.license       = 'MIT'

  spec.required_ruby_version     = '>= 1.9.3'
  spec.required_rubygems_version = '>= 2.0.0'

  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'simple_enum', '~> 2.3'
  spec.add_development_dependency 'activerecord', '>= 4.0.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
