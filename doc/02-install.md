# INSTALL

Install:

`gem install ayadn`  

Update:

`gem update ayadn`  

Uninstall:

`gem uninstall ayadn`  

## OS X, LINUX, BSD

Install Ayadn, authorize your account: done.

## RUBY

If you need to install Ruby it's better to use something like RVM or RBENV. You can of course use the Ruby shipped with your system but it will require root privileges and is not recommended.

## WINDOWS

Ayadn also works on Windows because it's pure Ruby, but some Gems it depends upon require some effort to be installed with some Windows versions ("amalgalite", notably). And you will need an ANSI compatible console (ConEmu, Console2, etc) and Ruby 2.0.0+ 32bits via RubyInstaller and its DevKit (or a cygwin equivalent). 

## MIGRATE

### From Ayadn 2.x to 3.x

There's nothing to do, just update the Gem.

### From Ayadn 1.x to 2.x

If you have an old Ayadn 1.x install that you want to keep using with Ayadn 2.x, Ayadn 2.x will ask you to run the `migrate` command (once) for this account.

Otherwise it's better to start with a fresh configuration: just delete your old 1.0 `~/ayadn` folder before authorizing the user again with Ayadn 2.x.

### From Ayadn 1.x to 3.x

Ayadn 3.x is not compatible at all with Ayadn 1.x. Delete your `~/ayadn` folder before authorizing the user again with Ayadn 3.x.

## DEPENDENCIES

Ayadn depends upon these Gems:

        amalgalite (SQLite)
        fast_cache (in-memory caching)
        pinboard (export to Pinboard)
        rainbow (text UI utilities)
        rest-client (networking)
        spotlite (IMDb access)
        terminal-table (text UI utilities)
        thor (commands and options parsing)
        tvdb_party (TVDb access)
        unicode_utils (text utilities)
        daybreak (Ruby data store)

*Note: the "daybreak" dependency is only needed for 1.x to 2.x migrations. Deprecated since Ayadn 3.0.*
