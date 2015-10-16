# encoding: utf-8

begin
  require_relative 'ayadn/version'
  %w{rest_client json thor rainbow/ext/string terminal-table yaml logger fileutils io/console unicode_utils readline amalgalite}.each { |r| require "#{r}" }
  Rainbow.enabled = true
  require_relative 'ayadn/app'
rescue LoadError => e
  puts "\nAYADN: Error while loading Gems\n\n"
  puts "RUBY: #{e}\n\n"
  exit
rescue Interrupt
  puts "\nExit: stopped by user while launching\n\n"
  exit
end


