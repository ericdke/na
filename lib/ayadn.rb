require_relative "ayadn/version"
#require 'awesome_print'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak}.each { |r| require "#{r}" }

require_relative "ayadn/app"
