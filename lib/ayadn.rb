# encoding: utf-8
require_relative 'ayadn/version'

begin
  %w{rest_client json thor rainbow/ext/string terminal-table yaml logger fileutils io/console unicode_utils/char_type readline amalgalite fast_cache}.each { |r| require "#{r}" }
rescue LoadError => e
  puts "\nAYADN: Error while loading Gems\n\n"
  puts "RUBY: #{e}\n\n"
  exit
end

Rainbow.enabled = true

require_relative 'ayadn/app'
