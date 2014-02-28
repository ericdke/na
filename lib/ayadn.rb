require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak pinboard fileutils}.each { |r| require "#{r}" }

require_relative 'ayadn/app'
