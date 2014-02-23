require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::View do

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
		  expect(printed).to include "\e[31m23184500\e[0m"
		  expect(printed).to include "\e[0m\n\nBacker of the Day"
		end
	end

	describe "#show_posts_with_index" do
		it 'outputs the indexed stream' do
		  printed = capture_stdout do
		    Ayadn::View.new.show_posts_with_index(data['data'])
		  end
		  expect(printed).to include "\e[31m001\e[0m\e[31m:"
		  expect(printed).to include "\e[0m\n\nBacker of the Day"
		end
	end













end