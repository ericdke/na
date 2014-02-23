require 'spec_helper'
require 'helpers'

describe Ayadn::Action do
	let(:action) { Ayadn::Action.new }

	describe "#add_arobase_if_absent" do
		after do
			Ayadn::Databases.close_all
		end
		it 'adds @ to username' do
			expect(action.add_arobase_if_absent(["user"])).to eq "@user"
		end
		it 'does nothing to @username' do
			expect(action.add_arobase_if_absent(["@user"])).to eq "@user"
		end
	end

	describe "#view_settings" do
		it 'outputs the settings' do
		  printed = capture_stdout do
		    action.view_settings
		  end
		  expect(printed).to include "Ayadn settings"
		end
	end

end