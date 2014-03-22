# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ayadn/version'

Gem::Specification.new do |spec|
  spec.name          = "ayadn"
  spec.version       = Ayadn::VERSION
  spec.author       = "Eric Dejonckheere"
  spec.email         = "eric@aya.io"
  spec.summary       = %q{App.net command-line client.}
  spec.description   = %q{App.net command-line client: toolbox to access and manage your ADN data, show your streams, manage conversations, star/follow/repost... and many, many more.}
  spec.homepage      = "http://ayadn-app.net"
  spec.license       = "MIT"

  spec.bindir        = 'bin'
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = %w{ayadn}
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "thor", ">= 0.18"
  spec.add_dependency "rest-client", ">= 1.6"
  spec.add_dependency "rainbow", ">= 2.0"
  spec.add_dependency "terminal-table", ">= 1.4"
  spec.add_dependency "daybreak", ">= 0.3"
  spec.add_dependency "pinboard"

  spec.add_development_dependency "bundler", ">= 1.5"
  spec.add_development_dependency "rake", ">= 10.1"
  spec.add_development_dependency "rspec", ">= 2.14"
  spec.add_development_dependency "rb-fsevent", ">= 0.9"
  spec.add_development_dependency "guard-rspec", ">= 4.2"
  spec.add_development_dependency "fakefs", ">= 0.5"

  spec.post_install_message = "Thanks for installing Ayadn! Please run 'ayadn -auth' to login with your App.net credentials."
end
