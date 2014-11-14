require 'spec_helper'

describe String do
  describe "is_integer?" do
    it 'returns true if string is an integer and not 0' do
      expect("1".is_integer?).to eq true
    end
    it 'returns true if string is an integer and not 0' do
      expect("01".is_integer?).to eq true
    end
    it 'returns true if string is an integer and not 0' do
      expect("331299".is_integer?).to eq true
    end
    it 'returns true if string is an integer and not 0' do
      expect("000331299".is_integer?).to eq true
    end
    it 'returns false if string is not an integer or is 0' do
      expect("0".is_integer?).to eq false
    end
    it 'returns false if string is not an integer or is 0' do
      expect("yolo".is_integer?).to eq false
    end
  end
end
