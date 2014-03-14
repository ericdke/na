require 'spec_helper'

describe Ayadn::API do
	before do
    Ayadn::Settings.load_config
  end
  describe ".build_query" do
    it 'returns a URL with count=12' do
      expect(Ayadn::API.build_query({count: 12})).to match /count=12/
    end
    it 'returns a URL with count=50' do
      expect(Ayadn::API.build_query(Ayadn::Settings.options)).to match /count=50/
    end
    it 'returns a URL with directed=0' do
      expect(Ayadn::API.build_query({directed: 0})).to match /directed=0/
    end
    it 'returns a URL with directed=1' do
      expect(Ayadn::API.build_query(Ayadn::Settings.options)).to match /directed=1/
    end
    it 'returns a URL with deleted=1' do
      expect(Ayadn::API.build_query({deleted: 1})).to match /deleted=1/
    end
    it 'returns a URL with deleted=0' do
      expect(Ayadn::API.build_query(Ayadn::Settings.options)).to match /deleted=0/
    end
    it 'returns a URL with html=1' do
      expect(Ayadn::API.build_query({html: 1})).to match /html=1/
    end
    it 'returns a URL with html=0' do
      expect(Ayadn::API.build_query(Ayadn::Settings.options)).to match /html=0/
    end
    it 'returns a URL with annotations=0' do
      expect(Ayadn::API.build_query({annotations: 0})).to match /annotations=0/
    end
    it 'returns a URL with annotations=1' do
      expect(Ayadn::API.build_query(Ayadn::Settings.options)).to match /annotations=1/
    end
  end
  describe "#check_response_meta_code" do
    it "returns original response if code is 200" do
      res = {'meta' => { 'code' => 200 }}
      expect(Ayadn::API.new.check_response_meta_code(res)).to eq res
    end
  end
end
