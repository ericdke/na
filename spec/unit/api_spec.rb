require 'spec_helper'

describe Ayadn::API do
	before do
    Ayadn::Settings.stub(:options).and_return({
        counts: {
          default: 50
        },
        timeline: {
          directed: 1,
          deleted: 0,
          html: 0,
          annotations: 1
        }
      })
  end
  describe ".build_query" do
    it 'returns a URL with count=12' do
      expect(Ayadn::API.build_query({count: 12})).to match /count=12/
    end
    it 'returns a URL with directed=0' do
      expect(Ayadn::API.build_query({directed: 0})).to match /directed=0/
    end
    it 'returns a URL with html=1' do
      expect(Ayadn::API.build_query({html: 1})).to match /html=1/
    end
  end
  describe "#check_response_meta_code" do
    it "returns original response if code is 200" do
      res = {'meta' => { 'code' => 200 }}
      expect(Ayadn::API.new.check_response_meta_code(res)).to eq res
    end
  end
end
