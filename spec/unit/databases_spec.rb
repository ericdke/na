require 'spec_helper'
require 'helpers'

describe Ayadn::Databases do
  before do
    Ayadn::Settings.stub(:config).and_return({
        paths: {
          db: 'spec/mock/',
          pagination: 'spec/mock/'
        }
      })
    Ayadn::Settings.stub(:options).and_return(
        {
          timeline: {
            show_debug: false
          }
        }
      )
    Ayadn::Databases.open_databases
  end
  describe ".add_to_users_db" do
    it "adds a user" do
      Ayadn::Databases.add_to_users_db(33, 'test', 'Mr Test')
      expect(Ayadn::Databases.all_users_ids).to eq [33]
      u = Ayadn::Databases.find_user_object_by_id(33)
      expect(u['test']).to eq 'Mr Test'
    end
  end
  describe ".add_to_users_db_from_list" do
    it "imports users from a list" do
      list = {12=>['yolo', 'Miss YOLO'], 666=>['lucy', 'Lucy Fair']}
      Ayadn::Databases.add_to_users_db_from_list(list)
      expect(Ayadn::Databases.all_users_ids).to eq [12, 666]
      u = Ayadn::Databases.find_user_object_by_id(12)
      expect(u['yolo']).to eq 'Miss YOLO'
      u = Ayadn::Databases.find_user_object_by_id(666)
      expect(u['lucy']).to eq 'Lucy Fair'
    end
  end
  describe ".save_max_id" do
    it "saves pagination" do
      stream = {'meta'=>{'max_id'=>'33666','marker'=>{'name'=>'test_stream'}}}
      Ayadn::Databases.save_max_id(stream)
      expect(Ayadn::Databases.all_pagination).to eq ['test_stream']
      expect(Ayadn::Databases.find_last_id_from('test_stream')).to eq 33666

      Ayadn::Databases.pagination_delete('test_stream')

      stream = {'meta'=>{'max_id'=>'12'}}
      Ayadn::Databases.save_max_id(stream, 'yolo')
      expect(Ayadn::Databases.all_pagination).to eq ['yolo']
      expect(Ayadn::Databases.find_last_id_from('yolo')).to eq 12
    end
  end
  describe ".has_new?" do
    it "check if new posts since last pagination record" do
      stream = {'meta'=>{'max_id'=>'33666','marker'=>{'name'=>'test_stream'}}}
      Ayadn::Databases.save_max_id(stream)
      expect(Ayadn::Databases.has_new?(stream, 'test_stream')).to eq false
      stream = {'meta'=>{'max_id'=>'42000000','marker'=>{'name'=>'test_stream'}}}
      expect(Ayadn::Databases.has_new?(stream, 'test_stream')).to eq true
    end
  end
  describe ".save_indexed_posts" do
    it "saves index" do
      posts = {'33666' =>{:count=>1},'424242' =>{:count=>2}}
      Ayadn::Databases.save_indexed_posts(posts)
      expect(Ayadn::Databases.get_post_from_index('424242')[:count]).to eq 2
    end
  end
  describe ".get_post_from_index" do
    it "gets post id from index" do
      posts = {'33666' =>{:count=>1, :id=>33666},'424242' =>{:count=>2, :id=>424242}}
      Ayadn::Databases.save_indexed_posts(posts)
      r = Ayadn::Databases.get_post_from_index(1)
      expect(r[:count]).to eq 1
      expect(r[:id]).to eq 33666
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
    Ayadn::Databases.close_all
  end
end
