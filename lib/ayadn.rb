# encoding: utf-8
require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger fileutils io/console unicode_utils/char_type readline amalgalite}.each { |r| require "#{r}" }

require_relative 'ayadn/app'
