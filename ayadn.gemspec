# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ayadn/version'

Gem::Specification.new do |spec|
  spec.name          = "ayadn"
  spec.version       = Ayadn::VERSION
  spec.authors       = ["Eric Dejonckheere"]
  spec.email         = ["eric@aya.io"]
  spec.summary       = %q{App.net command-line client.}
  spec.description   = %q{App.net command-line client: powertool to access and manage your ADN data, show your streams, manage conversations, use your files, etc.}
  spec.homepage      = "http://ayadn-app.net"
  spec.license       = "Custom"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
