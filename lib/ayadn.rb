# encoding: utf-8
require_relative 'ayadn/version'

%w{rest_client json thor rainbow/ext/string terminal-table yaml logger daybreak fileutils io/console}.each { |r| require "#{r}" }

require_relative 'ayadn/app'
