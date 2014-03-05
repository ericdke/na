require 'spec_helper'

describe Ayadn::Descriptions do
	describe ".unified" do
		it 'returns a string' do
			expect(Ayadn::Descriptions.unified).to include "Unified Stream, aka your App.net timeline"
            end
	end
end
