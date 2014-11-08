# encoding: utf-8
module Ayadn
  class Switch

    def initialize
      @thor = Thor::Shell::Color.new # local statuses
      @status = Status.new # global statuses + utils
      @acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
    end

    def list
      accounts = Databases.all_accounts(@acc_db)
      please if accounts.empty?
      accounts.sort_by! { |acc| acc[0] }
      cols = [['Username', 'Status', 'ID', 'Path'], ['', '', '', '']]
      accounts.each do |acc|
        username = acc[2]
        id = acc[1]
        active = 'AUTHORIZED'
        if acc[4] == 1
          active = 'ACTIVE'
        end
        cols << [username, active, id, acc[3]]
      end
      @status.say do
        @thor.print_table(cols)
      end
    end

    def switch(user)
      if user.empty? || user.nil?
        @status.no_username
        exit
      end
      username = Workers.new.remove_arobase_if_present([user.first])[0]
      accounts = Databases.all_accounts(@acc_db)
      please if accounts.empty?
      active = accounts.select { |acc| acc[4] == 1 }[0]
      active_user = active[0]
      if username == active_user
        @status.say do
          @thor.say_status :done, "already authorized with username @#{username}", :green
        end
        exit
      end
      flag = accounts.select { |acc| acc[0] == username }.flatten
      if flag.empty?
        @status.say do
          @thor.say_status :error, "@#{username} isn't in the database", :red
          @thor.say_status :next, "please run `ayadn -auth` to authorize this account", :yellow
        end
        exit
      else
        @status.say do
          @thor.say_status :switching, "from @#{active_user} to @#{username}", :cyan
          Databases.set_active_account(@acc_db, username)
          @thor.say_status :done, "@#{username} is now the active account", :green
        end
        exit
      end
    end

    private

    def please
      @status.say do
        @thor.say_status :error, "please run `ayadn -auth` to authorize an account", :red
      end
      exit
    end
  end
end
