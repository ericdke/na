# encoding: utf-8
require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak fileutils io/console unicode_utils/char_type readline}.each { |r| require "#{r}" }

# winPlatforms = ['mswin', 'mingw', 'mingw_18', 'mingw_19', 'mingw_20', 'mingw32']
# case Gem::Platform.local.os
# when *winPlatforms
#   require 'win32console'
#   require 'pstore'
# end

require_relative 'ayadn/app'
