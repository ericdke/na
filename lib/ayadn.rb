require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak fileutils}.each { |r| require "#{r}" }

require_relative 'ayadn/app'
