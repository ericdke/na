require 'spec_helper'
require 'helpers'

describe Ayadn::Action do
	let(:action) { Ayadn::Action.new }

	describe "#view_settings" do
		it 'outputs the settings' do
		  printed = capture_stdout do
		    action.view_settings
		  end
		  expect(printed).to include *["Current Ayadn settings","auto_save_sent_posts","whoreposted", "Category", "Parameter", "Value(s)"]
		end
	end

end
