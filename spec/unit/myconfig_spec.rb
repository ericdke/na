require 'spec_helper'

describe Ayadn::Settings do
	before do
		Ayadn::Settings.load_config
	end
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
			expect(opt).to have_key :scroll
		end
	end
	describe ".config" do
		it 'is a hash of defaults settings' do
			expect(cfg).to be_kind_of Hash
		end
		it 'has keys' do
			expect(cfg).to have_key :paths
			expect(cfg).to have_key :identity
		end
	end
end
