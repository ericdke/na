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

	let(:data) { JSON.parse(IO.read("spec/mock/stream.json")) }

	describe "#build_posts" do
		it "builds posts hash from stream" do
			posts = Ayadn::Workers.new.build_posts(data['data'])
			expect(posts[23187363][:name]).to eq "App.net Staff"
			expect(posts[23184500][:username]).to eq "wired"
			expect(posts[23185033][:handle]).to eq "@hackernews"
		end
	end

	let(:list) { {"007"=>["bond", "James Bond", true, true], "666"=>["mrtest", "Mr Test", false, false]} }

	describe "#build_users_array" do
		it "changes stored list into array of hashes" do
			resp = Ayadn::Workers.new.build_users_array(list)
			expect(resp[0][:username]).to eq "bond"
			expect(resp[0][:you_follow]).to be true
			expect(resp[1][:name]).to eq "Mr Test"
		end
	end

	describe "#build_followers_list" do
		it 'builds the followers table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_followers_list(list, "@test")
		  end
		  expect(printed).to include "+----"
		  expect(printed).to include "@test"
		  expect(printed).to include "@bond"
		  expect(printed).to include "Mr Test"
		end
	end

	describe "#build_followings_list" do
		it 'builds the followings table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_followings_list(list, "@test")
		  end
		  expect(printed).to include "+----"
		  expect(printed).to include "@test"
		  expect(printed).to include "@bond"
		  expect(printed).to include "Mr Test"
		end
	end

	describe "#build_muted_list" do
		it 'builds the muted table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_muted_list(list)
		  end
		  expect(printed).to include "+----"
		  expect(printed).to include "@bond"
		  expect(printed).to include "Mr Test"
		end
	end

	describe "#build_blocked_list" do
		it 'builds the blocked table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_blocked_list(list)
		  end
		  expect(printed).to include "+----"
		  expect(printed).to include "@bond"
		  expect(printed).to include "Mr Test"
		end
	end

	let(:alt_list) { [{"username" => "test", "name" => "Mr Test", "you_follow" => true, "follows_you" => false}] }

	describe "#build_reposted_list" do
		it 'builds the reposted table list' do
		  printed = capture_stdout do
		    puts Ayadn::Workers.new.build_reposted_list(alt_list, 42)
		  end
		  expect(printed).to include "+----"
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
		  expect(printed).to include "+----"
		  expect(printed).to include "42"
		  expect(printed).to include "@test"
		  expect(printed).to include "Mr Test"
		end
	end
end