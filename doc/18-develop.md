# DEVELOP

Ayadn is an Open Source project under the MIT license.

You can develop with Ayadn in several ways: build your own Ayadn-based client, add features to the official one, fix bugs, etc.

## First step

The [repository](https://github.com/ericdke/na) doesn't always have a development branch. If it has one, use it - otherwise it means the previous one has been merged or dismissed and you have to fork the master branch.

The first step in any case is to [fork](https://help.github.com/articles/fork-a-repo/) then clone the repository:

    $ git clone git@github.com:you/na.git && cd na

Run Bundler to ensure you have the proper dependencies installed:

    $ bundle

If you have the Ayadn Gem already installed, the currently logged in user will be used:

    $ ./bin/ayadn -tl

Otherwise you will have to authorize first:

    $ ./bin/ayadn -auth

Then for the Ayadn credentials itself, they're not included in the repository, so you will have to make a new `lib/ids.rb` file following this template:

<pre>
    <code class="ruby">
# encoding: utf-8
module Ayadn
  class Settings
    # Mandatory
    CLIENT_ID = "xxx"
  end
  class Endpoints
    # Mandatory
    CALLBACK_URL = "http://yourdomain.com/appname.html"
  end
  class NowPlaying
    # Optional
    AFFILIATE_SUFFIX = "&at=xxx&ct=appname"
    DEEZER_APP_ID = "xxx"
    DEEZER_AUTH_URL = "http://yourdomain.com/deezer.html"
  end
end
    </code>
</pre>

*Be careful to not modify your `.gitignore` file, these credentials should always be ignored and its contents never be accessible from any public location.*

## Tests

### RSPEC

Ayadn has a set of *rspec* unit tests.

They're convenient but far from perfect, so you're welcome to improve them or add new ones (some classes like `FileOps` or `CNX` notably lack testing at the moment).

Ayadn tests include mock data (adapted from real data) like stream and user JSON responses, and also a dedicated SQLite mock file.

Just launch `rspec` to run the battery of tests:

    $ rspec

### Debug

For live simulations and debug sessions, launch *irb* or *pry* then require `ayadn`:

    $ pry
    pry(main)> require_relative "lib/ayadn"

Then, to be "live", initialize the `Action` class:

    pry(main)> action = Ayadn::Action.new

You can now issue commands to Ayadn, for example:

    pry(main)> action.userinfo ["me"], {"raw"=>true}

*Be careful to use a test account when using Ayadn live like this...*

## Pull requests

You've added a feature or fixed a bug? Awesome! You're a hero!

Now you just have to open a Pull Request and wait until I examine your proposition and give you feedback.

## Make your own version

If you want to use (parts of) this codebase to create your own version of Ayadn, you will have to fill in several identifiers before release:

- Ayadn's client id
- Ayadn's callback URL for authentication

Optionally, if you keep those features:

- NowPlaying's iTunes affiliate suffix
- Deezer App id
- Deezer callback URL for authentication

**You will also have to create a new application in your App.net dashboard.**

*Don't forget to follow the License's rules before release. And although not mandatory, I'll be glad if you send me a message about your work. :)*

## Dive In

It's always hard to dive in an unknown codebase.

It's even more difficult when this codebase has a lot of legacy code and most of it is mediocre.

Unfortunately Ayadn is like that. ¯\(ツ)/¯ 

It was my first "big" app when I started developing in Ruby, so the code reflects that and suffers from the "lasagna syndrome": layers of new code upon layers of old code during years of development.

The biggest issue with the current codebase is not the code quality but its architecture, which is, to be polite, far from ideal, and not even really based on OOP principles - there's a lot of purely imperative code and other atrocities.

That being said, I believe my nomenclature for most methods and properties is self-explanatory enough, and there's comments where the code is a bit hairy or unclear.

As for the architecture, here's a brief overview.

### CLI

The first important step of the control flow is the `app.rb` class which intercepts the commands from the CLI.

This class inherits from `Thor` and only serves the purpose of being an interface for the CLI. Thor handles the IO of arguments and options, and also generates descriptions and help for the CLI commands.

From there, most commands will pass options and commands to the main dispatcher, the `Action` class (`action.rb`).

It initializes the user account credentials from the SQLite database and creates the main objects.

This is why you have to initialize `Action` yourself to use a live account if you're not using the CLI via `App`.

Follow what `Action`'s `initialize` does to understand the init process - it's scattered but easy to grasp.

### Action

The `Action` class launches the commands themselves (all commands that needed to have the credentials initialized).

Most of the commands in `Action` actually launch instances of the `Stream` class - other commands are implemented in `Action` itself or in topical classes like `Set` or `BlackList`.

### API

The `Endpoints` class holds all necessary endpoints and URLs.

The `API` class uses them to get the JSON responses from the ADN servers (using the `CNX` class for networking) and return a parsed version as a Ruby Hash. This class also handles the generation of query URLs from passed arguments.

Most commands will create custom Ayadn objects from these hashes, like `StreamObject` or `UserObject`, but for legacy reasons this is not how the global architecture works, and there's still places where the Hashes are used directly instead of handling custom objects.

### Main classes

The most used classes are the "God" classes `Workers`, `View` and `Status`.

`Workers` holds all utilities and workforce operations.

`View` creates colored and formatted text outputs.

`Status` holds all text messages: interface, errors, statuses, help, etc.

The `Workers` and `View` classes could really appreciate a rework and some DRY refactoring... but they currently work pretty well without known bugs so it's already something I suppose. ;)




