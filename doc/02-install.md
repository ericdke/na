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

## MIGRATE

The database format has changed between 1.x and 2.x: if you already have one or several authorized accounts, Ayadn will ask you to run the `migrate` command once per account. You only have to do this once.

You can also start with a fresh configuration: just delete your `~/ayadn` folder before authorizing a new user with Ayadn 2.x.

## WINDOWS

Ayadn also works on Windows because it's pure Ruby, but some Gems it depends upon require some effort to be installed with some Windows versions ("amalgalite", notably). And you will need an ANSI compatible console (ConEmu, Console2, etc) + Ruby 2.0.0 32bits via RubyInstaller and its DevKit (or a cygwin equivalent). 

## DEPENDENCIES

Ayadn depends upon these Gems:

        amalgalite
        fast_cache
        pinboard
        rainbow
        rest-client
        spotlite
        terminal-table
        thor
        tvdb_party
        unicode_utils
        daybreak

The "daybreak" dependency is only needed for 1.x to 2.x migrations. As this migration is optional and Ayadn 1.x is deprecated, this dependency will be removed in future versions.
