require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::View do
#	let(:action) { Ayadn::Action.new }
	before do
		Ayadn::MyConfig.load_config
		Ayadn::Logs.create_logger
		Ayadn::Databases.open_databases
	end

	after do
		Ayadn::Databases.close_all
	end

	describe "#settings" do
		it 'outputs the settings' do
		  printed = capture_stdout do
		    Ayadn::View.new.settings
		  end
		  expect(printed).to include "Ayadn settings"
		end
	end

	let(:data) { JSON.parse(IO.read("spec/mock/stream.json")) }

	describe "#show_posts" do
		it 'outputs the stream' do
		  printed = capture_stdout do
		    Ayadn::View.new.show_posts(data['data'])
		  end
		  expect(printed).to include "by Julia Cory"
		end
	end

end