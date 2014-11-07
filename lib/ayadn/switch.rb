# encoding: utf-8
module Ayadn
  class Switch

    def list
      acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      accounts = Databases.all_accounts(acc_db)
      please if accounts.empty?
      accounts.sort_by! { |acc| acc[0] }
      @thor = Thor::Shell::Color.new
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
       puts "\n"
      @thor.print_table(cols)
      puts "\n"
    end

    def switch(user)
      if user.empty? || user.nil?
        puts "\n\nOops, something went wrong, I couldn't get your username. Please try again.\n\n".color(:red)
        exit
      end
      username = Workers.new.remove_arobase_if_present([user.first])[0]
      acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      accounts = Databases.all_accounts(acc_db)
      please if accounts.empty?
      active = accounts.select { |acc| acc[4] == 1 }[0]
      active_user = active[0]
      if username == active_user
        puts "\nYou're already authorized with username '@#{username}'.\n".color(:red)
        exit
      end
      flag = accounts.select { |acc| acc[0] == username }.flatten
      if flag.empty?
        puts "\nThis account isn't in the database. Please run `ayadn -auth`.\n".color(:red)
        exit
      else
        puts "\nSwitching to account @#{username}...".color(:green)
        Databases.set_active_account(acc_db, username)
        puts Status.done
        exit
      end
    end

    private

    def please
      puts "\nPlease run `ayadn -auth` first.\n".color(:red)
      exit
    end
  end
end
