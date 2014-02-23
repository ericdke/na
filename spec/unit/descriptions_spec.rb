require 'spec_helper'

describe Ayadn::Descriptions do
	describe ".unified" do
		it 'returns a string' do
			Ayadn::Descriptions.unified.should == "Shows your Unified Stream.\nShortcut: replace 'unified' by '-U'."
		end
	end
end