require 'spec_helper'

describe Ayadn::MyConfig do
	Ayadn::MyConfig.load_config
	describe ".options" do
		it 'returns a hash of defaults settings' do
			Ayadn::MyConfig.options.should be_kind_of Hash
		end
	end
	describe ".config" do
		it 'returns a hash of defaults settings' do
			Ayadn::MyConfig.config.should be_kind_of Hash
		end
	end
	describe ".user_token" do
		it 'checks that token string is loaded' do
			Ayadn::MyConfig.user_token.should be_kind_of String
		end
	end
	describe ".load_config" do
		it 'checks the creation/existence of default directories' do
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:home])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:log])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:db])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:pagination])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:auth])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:downloads])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:backup])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:posts])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:messages])
			expect(Dir).to exist(Ayadn::MyConfig.config[:paths][:lists])
		end
		it 'checks the creation/existence of default files' do
			expect(File).to exist(Ayadn::MyConfig.config[:paths][:config] + "/config.yml")
			expect(File).to exist(Ayadn::MyConfig.config[:paths][:config] + "/version.yml")
		end
	end
	describe ".build_query_options" do
		it 'should return a string of the URL' do
			Ayadn::MyConfig.build_query_options({count: 12}).should =~ /&count=12&/
		end
	end
end