require_relative "ayadn/version"

%w{json thor}.each { |r| require "#{r}" }

require_relative "ayadn/app"