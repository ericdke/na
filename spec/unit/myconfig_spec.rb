require 'spec_helper'

describe Ayadn::MyConfig do
	let(:myconfig) { Ayadn::MyConfig.new }
	describe "#options" do
		it 'returns a hash of defaults settings' do
			myconfig.options.should be_kind_of Hash
		end
	end
	describe "#config" do
		it 'returns a hash of defaults settings' do
			myconfig.config.should be_kind_of Hash
		end
	end
	describe "#user_token" do
		it 'checks that token string is loaded' do
			myconfig.user_token.should be_kind_of String
		end
	end
	describe "#load_config" do
		it 'checks the creation/existence of default directories' do
			expect(Dir).to exist(myconfig.config[:paths][:home])
			expect(Dir).to exist(myconfig.config[:paths][:log])
			expect(Dir).to exist(myconfig.config[:paths][:db])
			expect(Dir).to exist(myconfig.config[:paths][:pagination])
			expect(Dir).to exist(myconfig.config[:paths][:auth])
			expect(Dir).to exist(myconfig.config[:paths][:downloads])
			expect(Dir).to exist(myconfig.config[:paths][:backup])
			expect(Dir).to exist(myconfig.config[:paths][:posts])
			expect(Dir).to exist(myconfig.config[:paths][:messages])
			expect(Dir).to exist(myconfig.config[:paths][:lists])
		end
		it 'checks the creation/existence of default files' do
			expect(File).to exist(myconfig.config[:paths][:config] + "/config.yml")
			expect(File).to exist(myconfig.config[:paths][:config] + "/version.yml")
		end
	end
	describe "#build_query_options" do
		it 'should return a string of the URL' do
			myconfig.build_query_options({count: 12}).should =~ /&count=12&/
		end
	end
end