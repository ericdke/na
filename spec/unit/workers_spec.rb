require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::Workers do

	before do
		Ayadn::MyConfig.load_config
		Ayadn::Logs.create_logger
		Ayadn::Databases.open_databases
	end

	after do
		Ayadn::Databases.close_all
	end

	let(:list) { {"007"=>["bond", "James Bond", true, true], "666"=>["manynames", "The Shadow", false, false]} }

	describe "#build_followers_list" do
		it 'builds the followers table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_followers_list(list, "@test")
		  end
		  expect(printed).to include "@test"
		  expect(printed).to include "@bond"
		  expect(printed).to include "The Shadow"
		end
	end

	let(:alt_list) { [{"username" => "test", "name" => "Mr Test", "you_follow" => true, "follows_you" => false}] }

	describe "#build_reposted_list" do
		it 'builds the reposted table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_reposted_list(alt_list, 42)
		  end
		  expect(printed).to include "42"
		  expect(printed).to include "@test"
		  expect(printed).to include "Mr Test"
		end
	end

	describe "#build_starred_list" do
		it 'builds the starred table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_starred_list(alt_list, 42)
		  end
		  expect(printed).to include "42"
		  expect(printed).to include "@test"
		  expect(printed).to include "Mr Test"
		end
	end
end