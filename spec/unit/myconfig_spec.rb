require 'spec_helper'

describe Ayadn::MyConfig do
	describe "#options" do
		it 'returns a hash of defaults settings' do
			subject.options.should be_kind_of Hash
			
		end
	end
end