require 'spec_helper'

describe Ayadn::Descriptions do
	describe ".unified" do
		it 'returns a string' do
			expect(Ayadn::Descriptions.unified).to include "Show your App.net timeline, aka the Unified Stream"
            end
	end
end
