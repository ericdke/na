require 'spec_helper'

describe Ayadn::Action do
	after do
		Ayadn::Databases.close_all
	end
	describe "#add_arobase_if_absent" do
		it 'adds @ to username' do
			expect(Ayadn::Action.new.add_arobase_if_absent(["user"])).to eq "@user"
		end
		it 'does nothing to @username' do
			expect(Ayadn::Action.new.add_arobase_if_absent(["@user"])).to eq "@user"
		end
	end
end