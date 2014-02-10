require_relative "ayadn/version"

%w{rest_client json thor awesome_print}.each { |r| require "#{r}" }

require_relative "ayadn/app"