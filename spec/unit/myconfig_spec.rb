require 'spec_helper'

describe Ayadn::MyConfig do
	Ayadn::MyConfig.load_config
	subject(:opt) { Ayadn::MyConfig.options }
	subject(:cfg) { Ayadn::MyConfig.config }
	describe ".options" do
		it 'returns a hash of defaults settings' do
			opt.should be_kind_of Hash
			expect(opt).to include :counts
			expect(opt).to include :timeline
			expect(opt).to include :formats
			expect(opt).to include :colors
			expect(opt).to include :backup
			expect(opt).to include :identity
			expect(opt).to include :pinboard
		end
	end
	describe ".config" do
		it 'returns a hash of defaults settings' do
			cfg.should be_kind_of Hash
		end
	end
	describe ".user_token" do
		it 'checks that token string is loaded' do
			Ayadn::MyConfig.user_token.should be_kind_of String
		end
	end
	describe ".load_config" do
		it 'checks the creation/existence of default directories' do
			expect(Dir).to exist(cfg[:paths][:home])
			expect(Dir).to exist(cfg[:paths][:log])
			expect(Dir).to exist(cfg[:paths][:db])
			expect(Dir).to exist(cfg[:paths][:pagination])
			expect(Dir).to exist(cfg[:paths][:auth])
			expect(Dir).to exist(cfg[:paths][:downloads])
			expect(Dir).to exist(cfg[:paths][:backup])
			expect(Dir).to exist(cfg[:paths][:posts])
			expect(Dir).to exist(cfg[:paths][:messages])
			expect(Dir).to exist(cfg[:paths][:lists])
		end
		it 'checks the creation/existence of default files' do
			expect(File).to exist(cfg[:paths][:config] + "/config.yml")
			expect(File).to exist(cfg[:paths][:config] + "/version.yml")
		end
	end
	describe ".build_query_options" do
		it 'returns a URL with count=12' do
			Ayadn::MyConfig.build_query_options({count: 12}).should =~ /count=12/
		end
		it 'returns a URL with count=50' do
			Ayadn::MyConfig.build_query_options(Ayadn::MyConfig.options).should =~ /count=50/
		end
		it 'returns a URL with directed=0' do
			Ayadn::MyConfig.build_query_options({directed: 0}).should =~ /directed=0/
		end
		it 'returns a URL with directed=1' do
			Ayadn::MyConfig.build_query_options(Ayadn::MyConfig.options).should =~ /directed=1/
		end
		it 'returns a URL with deleted=1' do
			Ayadn::MyConfig.build_query_options({deleted: 1}).should =~ /deleted=1/
		end
		it 'returns a URL with deleted=0' do
			Ayadn::MyConfig.build_query_options(Ayadn::MyConfig.options).should =~ /deleted=0/
		end
		it 'returns a URL with html=1' do
			Ayadn::MyConfig.build_query_options({html: 1}).should =~ /html=1/
		end
		it 'returns a URL with html=0' do
			Ayadn::MyConfig.build_query_options(Ayadn::MyConfig.options).should =~ /html=0/
		end
		it 'returns a URL with annotations=0' do
			Ayadn::MyConfig.build_query_options({annotations: 0}).should =~ /annotations=0/
		end
		it 'returns a URL with annotations=1' do
			Ayadn::MyConfig.build_query_options(Ayadn::MyConfig.options).should =~ /annotations=1/
		end
	end
end