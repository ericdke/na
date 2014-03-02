require 'spec_helper'

describe Ayadn::Descriptions do
	describe ".unified" do
		it 'returns a string' do
			Ayadn::Descriptions.unified.should == "Shows your Unified Stream. Shortcut: replace 'unified' by '-u'."
		end
	end
end
