# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ayadn/version'

Gem::Specification.new do |spec|
  spec.name          = "ayadn"
  spec.version       = Ayadn::VERSION
  spec.author        = "Eric Dejonckheere"
  spec.email         = "eric@aya.io"
  spec.summary       = %q{App.net command-line client.}
  spec.description   = %q{App.net command-line client: toolbox to access and manage your ADN data, show your streams, post, manage conversations, star/follow/repost... and many, many more.}
  spec.homepage      = "https://github.com/ericdke/na"
  spec.license       = "MIT"
  spec.metadata      = { "documentation" => "https://github.com/ericdke/na/tree/master/doc" }

  spec.bindir        = 'bin'
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = %w{ayadn}
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "rest-client", "~> 1.7"
  spec.add_dependency "rainbow", "~> 2.0"
  spec.add_dependency "terminal-table", "~> 1.4"
  spec.add_dependency "daybreak", "~> 0.3"
  spec.add_dependency "pinboard", "~> 0.1"
  spec.add_dependency "unicode_utils", "~> 1.4"
  spec.add_dependency "spotlite", "~> 0.8"
  spec.add_dependency "tvdb_party", "~> 0.7"
  spec.add_dependency "amalgalite", "~> 1.3"
  spec.add_dependency "fast_cache", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "coveralls", "~> 0.7"

  spec.post_install_message = "Thank you for installing Ayadn!"
end
