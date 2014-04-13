# encoding: utf-8
require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak fileutils io/console}.each { |r| require "#{r}" }

# winPlatforms = ['mswin', 'mingw', 'mingw_18', 'mingw_19', 'mingw_20', 'mingw32']
# case Gem::Platform.local.os
# when *winPlatforms
#   require 'win32console'
# end

require_relative 'ayadn/app'
