require 'spec_helper'

describe Ayadn::Post do
  before do
    Ayadn::Settings.load_config
    Settings.get_token
    Settings.init_config
    Ayadn::Logs.create_logger
  end
  let(:post) { Ayadn::Post.new }

  describe "#text_is_empty?" do
    it "checks if empty" do
      post.text_is_empty?(["allo"]).should be false
      post.text_is_empty?([""]).should be true
      post.text_is_empty?([]).should be true
    end
  end

  describe "#markdown_extract" do
    it "splits markdown" do
      post.markdown_extract("[ayadn](http://ayadn-app.net)").should eq ["ayadn", "http://ayadn-app.net"]
    end
  end

  describe "#get_markdown_text" do
    it "extracts markdown text" do
      post.get_markdown_text("[ayadn](http://ayadn-app.net)").should eq "ayadn"
    end
  end

  describe "#check_post_length" do
    it "checks normal post/message length" do
      post.check_post_length(["allo", "wtf"]).should be nil #no error
    end
  end

end
