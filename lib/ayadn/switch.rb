# encoding: utf-8
module Ayadn
  class Switch

    def initialize
      @status = Status.new
      @acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
    end

    def list
      puts "\n"
      accounts = Databases.all_accounts(@acc_db)
      please if accounts.empty?
      accounts.sort_by! { |acc| acc[0] }
      table = Terminal::Table.new do |t|
        t.style = { :width => 80 }
        t.title = "Ayadn accounts"
        t.headings = ['Username', 'ID', 'Path']
      end
      accounts.each do |acc|
        username = acc[2]
        id = acc[1].to_s
        path = "~/ayadn/#{File.basename(acc[3])}"
        if acc[4] == 1
          username = username.color(:green)
          id = id.color(:green)
          path = path.color(:green)
        end
        table << [username, id, path]
      end
      puts table
      puts "\n"
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
          @status.say_green :done, "already authorized with username @#{username}"
        end
        exit
      end
      flag = accounts.select { |acc| acc[0] == username }.flatten
      if flag.empty?
        @status.say do
          @status.say_error "@#{username} isn't in the database"
          @status.say_yellow :next, "please run `ayadn -auth` to authorize this account"
        end
        exit
      else
        @status.say do
          @status.say_cyan :switching, "from @#{active_user} to @#{username}"
          Databases.set_active_account(@acc_db, username)
          @status.say_green :done, "@#{username} is now the active account"
        end
        exit
      end
    end

    private

    def please
      @status.say_info "please run `ayadn -auth` to authorize an account"
      puts
      exit
    end
  end
end
