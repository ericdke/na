require_relative "ayadn/version"

%w{rubygems json thor}.each { |r| require "#{r}" }

require_relative "ayadn/app"