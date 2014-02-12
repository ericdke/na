require_relative "ayadn/version"

%w{rest_client json thor awesome_print rainbow/ext/string terminal-table}.each { |r| require "#{r}" }

require_relative "ayadn/app"