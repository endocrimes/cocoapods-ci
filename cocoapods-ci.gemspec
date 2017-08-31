# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-ci/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-ci'
  spec.version       = CocoapodsCi::VERSION
  spec.authors       = ['Danielle Tomlinson', 'Samuel Giddins']
  spec.email         = ['dan@tomlinson.io', 'segiddins@segiddins.me']
  spec.description   = 'A CocoaPods plugin to install pods without having the specs repo'
  spec.homepage      = 'https://github.com/endocrimes/cocoapods-ci'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
