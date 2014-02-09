#!/usr/bin/env ruby
$PROGRAM_NAME = "ayadn"
require_relative '../lib/ayadn'

Ayadn::App.start ARGV
# a = Ayadn::Launcher.new
# puts a.methods