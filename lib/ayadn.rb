require_relative "ayadn/version"

%w{rubygems json thor highline/import}.each { |r| require "#{r}" }

require_relative "ayadn/app"