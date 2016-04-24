require 'spec_helper'
require 'helpers'

describe Ayadn::Databases do
  before do
    Ayadn::Settings.stub(:options).and_return({
        colors: {
          hashtags: :cyan,
          mentions: :red,
          username: :green,
          excerpt: :green
        },
        timeline: {compact: false},
        formats: {table: {width: 75}, list: {reverse: true}},
        blacklist: {active: true}
      })
    Ayadn::Settings.stub(:config).and_return({
      identity: {
        username: 'test',
        handle: '@test'
      },
      post_max_length: 256,
      message_max_length: 2048,
      version: 'wee',
      paths: {
        db: 'spec/mock/',
        log: 'spec/mock'
      }
    })
    Ayadn::Settings.stub(:global).and_return({
      scrolling: false,
      force: false
    })
    Ayadn::Logs.stub(:rec).and_return("logged")
    Dir.stub(:home).and_return("spec/mock")
    Ayadn::Databases.open_databases
  end

  let(:data) { JSON.parse(File.read("spec/mock/stream.json")) }

  describe ".add_to_users_db" do
    it "adds a user" do
      Ayadn::Databases.add_to_users_db(33, 'test', 'Mr Test')
      expect(Ayadn::Databases.all_users_ids).to eq [33]
      u = Ayadn::Databases.find_user_object_by_id(33)
      expect(u[2]).to eq 'Mr Test'
    end
  end
  describe ".add_to_users_db_from_list" do
    it "imports users from a list" do
      list = {12=>['yolo', 'Miss YOLO'], 666=>['lucy', 'Lucy Fair']}
      Ayadn::Databases.add_to_users_db_from_list(list)
      expect(Ayadn::Databases.all_users_ids).to eq [12, 666]
      u = Ayadn::Databases.find_user_object_by_id(12)
      expect(u[2]).to eq 'Miss YOLO'
      u = Ayadn::Databases.find_user_object_by_id(666)
      expect(u[0]).to eq 666
      expect(u[1]).to eq 'lucy'
      expect(u[2]).to eq 'Lucy Fair'
    end
  end
  describe ".save_max_id" do
    it "saves pagination" do
      stream_object = Ayadn::StreamObject.new(data)
      Ayadn::Databases.save_max_id(stream_object)
      expect(Ayadn::Databases.all_pagination).to eq ['unified', 23187443]
      expect(Ayadn::Databases.find_last_id_from('unified')).to eq 23187443
      Ayadn::Databases.pagination_delete('unified')
    end
  end
  describe ".has_new?" do
    it "check if new posts since last pagination record" do
      stream_object = Ayadn::StreamObject.new(data)
      Ayadn::Databases.save_max_id(stream_object)
      expect(Ayadn::Databases.has_new?(stream_object, 'unified')).to eq false
      temp = stream_object.input
      temp['meta']['max_id'] = '42000000'
      stream_object = Ayadn::StreamObject.new(temp)
      expect(Ayadn::Databases.has_new?(stream_object, 'unified')).to eq true
    end
  end
  describe ".save_indexed_posts" do
    it "saves index" do
      posts = {'33666' =>{:count=>1, :id=>33666},'424242' =>{:count=>2, :id=>424242}}
      Ayadn::Databases.save_indexed_posts(posts)
      expect(Ayadn::Databases.get_post_from_index('2')['id']).to eq 424242
    end
  end
  describe ".get_post_from_index" do
    it "gets post id from index" do
      posts = {'33666' =>{:count=>1, :id=>33666},'424242' =>{:count=>2, :id=>424242}}
      Ayadn::Databases.save_indexed_posts(posts)
      expect(Ayadn::Databases.get_post_from_index(1)['id']).to eq 33666
    end
  end
  describe ".create_alias" do
    it "creates an alias for a channel id" do
      Ayadn::Databases.create_alias('42','everything')
      expect(Ayadn::Databases.get_channel_id('everything')).to eq 42
    end
  end
  describe ".get_alias_from_id" do
    it "gets an alias from a channel id" do
      Ayadn::Databases.create_alias('42','everything')
      expect(Ayadn::Databases.get_alias_from_id('42')).to eq 'everything'
    end
  end
  after do
    Ayadn::Databases.clear_users
    Ayadn::Databases.clear_pagination
    Ayadn::Databases.clear_index
  end
end
