#!/usr/bin/env ruby
$PROGRAM_NAME = "Ayadn"
require_relative '../lib/ayadn'

Ayadn::App.start ARGV
# a = Ayadn::Launcher.new
# puts a.methods