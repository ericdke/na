require 'spec_helper'

describe Ayadn::Descriptions do
	describe ".unified" do
		it 'returns a string' do
			Ayadn::Descriptions.unified.should == "Show your Unified Stream. Example: 'ayadn -u'"
		end
	end
end
