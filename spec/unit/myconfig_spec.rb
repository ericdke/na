require 'spec_helper'

describe Ayadn::Settings do
	Ayadn::Settings.load_config
	subject(:opt) { Ayadn::Settings.options }
	subject(:cfg) { Ayadn::Settings.config }
	describe ".options" do
		it 'is a hash of defaults settings' do
			expect(opt).to be_kind_of Hash
		end
		it 'has keys' do
			expect(opt).to have_key :counts
			expect(opt).to have_key :timeline
			expect(opt).to have_key :formats
			expect(opt).to have_key :colors
			expect(opt).to have_key :backup
		end
	end
	describe ".config" do
		it 'is a hash of defaults settings' do
			expect(cfg).to be_kind_of Hash
		end
	end
	describe ".user_token" do
		it 'loads token string' do
			expect(Ayadn::Settings.user_token).to be_kind_of String
		end
		it 'is longer than 15 char' do
			expect(Ayadn::Settings.user_token.length).to be >= 15
		end
	end
	describe ".load_config" do
		it 'checks/makes default directories' do
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
		it 'checks for config file' do
			expect(File).to exist(cfg[:paths][:config] + "/config.yml")
		end
		it 'checks for version file' do
			expect(File).to exist(cfg[:paths][:config] + "/version.yml")
		end
	end
	describe ".build_query" do
		it 'returns a URL with count=12' do
			expect(Ayadn::Settings.build_query({count: 12})).to match /count=12/
		end
		it 'returns a URL with count=50' do
			expect(Ayadn::Settings.build_query(Ayadn::Settings.options)).to match /count=50/
		end
		it 'returns a URL with directed=0' do
			expect(Ayadn::Settings.build_query({directed: 0})).to match /directed=0/
		end
		it 'returns a URL with directed=1' do
			expect(Ayadn::Settings.build_query(Ayadn::Settings.options)).to match /directed=1/
		end
		it 'returns a URL with deleted=1' do
			expect(Ayadn::Settings.build_query({deleted: 1})).to match /deleted=1/
		end
		it 'returns a URL with deleted=0' do
			expect(Ayadn::Settings.build_query(Ayadn::Settings.options)).to match /deleted=0/
		end
		it 'returns a URL with html=1' do
			expect(Ayadn::Settings.build_query({html: 1})).to match /html=1/
		end
		it 'returns a URL with html=0' do
			expect(Ayadn::Settings.build_query(Ayadn::Settings.options)).to match /html=0/
		end
		it 'returns a URL with annotations=0' do
			expect(Ayadn::Settings.build_query({annotations: 0})).to match /annotations=0/
		end
		it 'returns a URL with annotations=1' do
			expect(Ayadn::Settings.build_query(Ayadn::Settings.options)).to match /annotations=1/
		end
	end
end
