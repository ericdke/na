module Ayadn

  class Databases

    class << self
      attr_accessor :users, :index
    end

    def self.open_databases
      @users = Daybreak::DB.new "#{MyConfig.config[:paths][:db]}/users.db"
      @index = Daybreak::DB.new "#{MyConfig.config[:paths][:pagination]}/index.db"
    end

    def self.close_all
      @users.flush
      @users.close
      @index.flush
      @index.close
    end

  end

end
