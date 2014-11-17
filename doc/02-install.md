# INSTALL

Install:

`gem install ayadn`  

Update:

`gem update ayadn`  

Uninstall:

`gem uninstall ayadn`  

## OS X, LINUX, BSD

Install the Gem, authorize, done.

If you need to install Ruby it's better to use something like RVM or RBENV. You can of course use the Ruby shipped with your system but it will require root privileges and is not recommended.

## WINDOWS

The console *has* to be fully ANSI compatible (example: ConEmu). Windows support is not 100% stable yet. Don't hesitate to fork and pull request!

## MIGRATE

The database format has changed between 1.x and 2.x: if you already have one or several authorized accounts, Ayadn will ask you to run the `migrate` command once per account. You only have to do this once.

You can also, if you wish, start anew and delete your `~/ayadn` folder before authorizing a new user with Ayadn 2.x.

## DEPENDENCIES

Ayadn depends on these Gems:

        amalgalite
        daybreak
        fast_cache
        pinboard
        rainbow
        rest-client
        spotlite
        terminal-table
        thor
        tvdb_party
        unicode_utils
