require 'spec_helper'

describe Ayadn::Status do
	describe ".done" do
		it 'returns a green Done string' do
			expect(Ayadn::Status.done).to eq("\e[32mDone.\n\e[0m")
		end
	end
end