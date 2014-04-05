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
    Ayadn::Databases.open_databases
  end
  describe ".add_to_users_db" do
    it "adds a user" do
      Ayadn::Databases.add_to_users_db(33, 'test', 'Mr Test')
      expect(Ayadn::Databases.users.keys).to eq ['33']
      u = Ayadn::Databases.users[33]
      expect(u['test']).to eq 'Mr Test'
    end
  end
  describe ".add_to_users_db_from_list" do
    it "imports users from a list" do
      list = {12=>['yolo', 'Miss YOLO'], 666=>['lucy', 'Lucy Fair']}
      Ayadn::Databases.add_to_users_db_from_list(list)
      expect(Ayadn::Databases.users.keys).to eq ['12', '666']
      u = Ayadn::Databases.users[12]
      expect(u['yolo']).to eq 'Miss YOLO'
      u = Ayadn::Databases.users[666]
      expect(u['lucy']).to eq 'Lucy Fair'
    end
  end
  after do
    Ayadn::Databases.users.clear
    Ayadn::Databases.close_all
  end
end
