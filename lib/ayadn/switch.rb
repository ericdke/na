# encoding: utf-8
module Ayadn
  class Switch

    def list
      home_path = Dir.home + "/ayadn"
      if File.exist?("#{home_path}/accounts.db")
        accounts_db = Databases.init("#{home_path}/accounts.db")
        active = accounts_db['ACTIVE']
        begin
          puts "\nCurrently authorized accounts:\n".color(:cyan)
          accounts_db.each do |acc|
            next if acc[0] == 'ACTIVE'
            if acc[1][:username] == active
              puts "#{acc[1][:handle]}".color(:red)
            else
              puts "#{acc[1][:handle]}".color(:green)
            end
          end
          puts "\n"
        ensure
          close_db(accounts_db)
        end
      else
        please
      end
    end

    def switch(user)
      if user.empty? || user.nil?
        puts "\n\nOops, something went wrong, I couldn't get your username. Please try again.\n\n".color(:red)
        exit
      end
      #puts "\e[H\e[2J"
      username = Workers.remove_arobase_if_present([user.first])[0]
      home_path = Dir.home + "/ayadn"
      if File.exist?("#{home_path}/accounts.db")
        accounts_db = Databases.init("#{home_path}/accounts.db")
        active = accounts_db['ACTIVE']
        if username == accounts_db[active][:username]
          puts "\nYou're already authorized with username '#{accounts_db[active][:handle]}'.\n".color(:red)
          cancel(accounts_db)
        end
        if accounts_db[username]
          puts "\nSwitching to account @#{username}...".color(:green)
          accounts_db['ACTIVE'] = username
          close_db(accounts_db)
          puts Status.done
          exit
        else
          puts "\nThis account isn't in the database. Please run 'ayadn authorize'.\n".color(:red)
          cancel(accounts_db)
        end
      else
        please
      end
    end

    private

    def cancel(accounts_db)
      accounts_db.close
      exit
    end
    def close_db(db)
      db.flush
      db.close
    end
    def please
      puts "\nPlease run 'ayadn authorize' first.\n".color(:red)
      exit
    end
  end
end
