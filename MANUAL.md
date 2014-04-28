- [INSTALL](#install)
	- [RUBY](#ruby)
	- [AYADN](#ayadn)
		- [OS X, LINUX, BSD](#os-x-linux-bsd)
- [FIRST STEPS](#first-steps)
	- [AUTHORIZE](#authorize)
	- [HELP](#help)
	- [EXAMPLES](#examples)
	- [ACCOUNTS](#accounts)
	- [DATA](#data)
- [HOW-TO](#how-to)
- [STREAMS](#streams)
	- [TIMELINE](#timeline)
		- [AVAILABLE OPTIONS](#available-options)
			- [SCROLL](#scroll)
			- [COUNT](#count)
			- [INDEX](#index)
			- [NEW](#new)
			- [RAW](#raw)
			- [EXTRACT](#extract)
	- [GLOBAL](#global)
	- [CHECKINS](#checkins)
	- [CONVERSATIONS](#conversations)
	- [TRENDING](#trending)
	- [MENTIONS](#mentions)
	- [POSTS](#posts)
	- [MESSAGES](#messages)
	- [WHATSTARRED](#whatstarred)
	- [CONVO](#convo)
	- [HASHTAG](#hashtag)
	- [SEARCH](#search)
	- [RANDOM](#random)
	- [USER INFO](#user-info)
	- [POST INFO](#post-info)
- [POSTING](#posting)
	- [POST](#post)
	- [WRITE](#write)
	- [AUTO POST](#auto-post)
	- [REPLY](#reply)
	- [PM (PRIVATE MESSAGE)](#pm-private-message)
	- [SEND](#send)
- [ACTIONS](#actions)
	- [DELETE](#delete)
	- [REPOST](#repost)
	- [UNREPOST](#unrepost)
	- [STAR](#star)
	- [UNSTAR](#unstar)
	- [FOLLOW](#follow)
	- [UNFOLLOW](#unfollow)
	- [MUTE](#mute)
	- [UNMUTE](#unmute)
	- [BLOCK](#block)
	- [UNBLOCK](#unblock)
	- [DOWNLOAD](#download)
- [LISTS](#lists)
	- [FOLLOWERS](#followers)
	- [FOLLOWINGS](#followings)
	- [CHANNELS](#channels)
	- [INTERACTIONS](#interactions)
	- [WHOREPOSTED](#whoreposted)
	- [MUTED](#muted)
	- [BLOCKED](#blocked)
	- [SETTINGS](#settings)
	- [FILES](#files)
- [TOOLS](#tools)
	- [AUTHORIZE](#authorize-1)
	- [SWITCH](#switch)
	- [BLACKLIST](#blacklist)
		- [ADD](#add)
		- [REMOVE](#remove)
		- [LIST](#list)
		- [IMPORT](#import)
	- [ALIAS](#alias)
		- [CREATE](#create)
		- [DELETE](#delete-1)
		- [LIST](#list-1)
		- [IMPORT](#import-1)
	- [SET](#set)
- [EXTRAS](#extras)
	- [PIN](#pin)
	- [NOWPLAYING](#nowplaying)

# INSTALL

## RUBY

Ayadn is compatible with Ruby 1.9.3 but works better with Ruby 2.0 or newer.  

## AYADN

Install:

`gem install ayadn`  

Update:

`gem update ayadn`

### OS X, LINUX, BSD

Please use something like RVM or RBENV to install Ruby if necessary.

You can also use the Ruby shipped with your system but it's not ideal, as it will probably require root privileges or using the 'sudo' command.  

# FIRST STEPS

## AUTHORIZE

You have to give Ayadn the authorization to use your App.net account. 

Just run `ayadn authorize` or `ayadn -auth` to register a new user.  

## HELP

`ayadn` shows a list of available commands.  

`ayadn help COMMAND` shows the instructions and available [options](#available-options) for a specific command. 

Examples:  

`ayadn help post`  

`ayadn help timeline`  

## EXAMPLES

Just a few examples to give you a hint at the flexible syntax:  

`ayadn timeline`

`ayadn -tl`

`ayadn checkins -c10 -i`

`ayadn global --scroll`

`ayadn -up @ericd`

`ayadn -P 'Hello guys!'`

`ayadn -R 23362460`

`ayadn convo 23362788`

`ayadn search movies hollywood`

`ayadn follow @ericd`  

## ACCOUNTS

Ayadn supports multiple accounts.

Register a new user with `ayadn -auth` at any moment.

You can then switch between accounts:

`ayadn switch @ericd` or `ayadn -@ ericd`  

## DATA

All Ayadn files and folders are created in your 'home' folder. 

On Mac OS X, it looks like this:

	/Users/ericdke/ayadn/
	├── accounts.db
	/Users/ericdke/ayadn/ericd
	├── auth
	│   └── token
	├── backup
	├── config
	│   ├── api.json
	│   ├── config.yml
	│   └── version.yml
	├── db
	│   ├── aliases.db
	│   ├── blacklist.db
	│   └── users.db
	├── downloads
	├── lists
	├── log
	│   └── ayadn.log
	├── messages
	├── pagination
	│   ├── index.db
	│   └── pagination.db
	└── posts

Each authorized account has its set of folders and databases.

This is also the repository of the configuration file, `config.yml`. 

Although there's the `set` command in Ayadn to configure most parameters, you can of course edit the file manually.

If you're not sure if your config file is up to date or properly filled and you want to benefit from the new options in Ayadn, run `ayadn set defaults` and it will create a brand new file with optimal values.


# HOW-TO

Note: options are only described once in this manual (in the first example, for 'timeline'). 

However, options are available for mosts of streams! They're described only once for readability purposes.

**You can check if a command has specific options with `ayadn help COMMAND`.**  
Most examples will include the 'complete' command followed by the 'shortcut' command. Of course, using Ayadn is way faster with the shortcut commands.

If you're like me, you'll even want to create aliases in bash/zsh or TextExpander snippets for the combinations of Ayadn commands and options you use the most...  


# STREAMS

This section is about the App.net streams.

## TIMELINE

Display your main timeline.

This is also called the 'Unified stream': it regroups the posts of people you follow and the posts mentioning you.

`ayadn timeline`

`ayadn -tl`


### AVAILABLE OPTIONS

#### SCROLL

Scroll your timeline with:

`ayadn timeline --scroll`

`ayadn -tl -s`

Note: Ayadn pulls the stream every 3 seconds by default. 

It means you can launch up to 3 scroll streams at a time _per account_. 

You can bring that value down to 1 second if you're using only _one_ scroll stream per account at a time, 2 seconds if you're using _two_ scroll streams, and so on and so forth.

If Ayadn ends up making too many requests to ADN, it will display an alert message with instructions then stop running.

So if you plan on launching many Ayadn scrolling instances at once, you should [set](#set) the timer parameter accordingly (App.net accepts 5000 requests per hour per account maximum).

#### COUNT

Ayadn displays a certain number of posts by default when you request a stream.

With the *count* option, you can set a specific value for each request:

`ayadn --count=10 timeline`

`ayadn -c10 -tl`

The maximum value is 200 for any stream.

#### INDEX

Shows an index instead of the posts ids.

`ayadn --index timeline`

`ayadn -tl -i`  

This is particularly useful if you're using Ayadn to [reply](#reply) to conversations.

Copy/pasting the post id can be tedious at times, and anyway it's faster to glance at a short number and use it immediately.

Example:

	ayadn -tl -i
	ayadn -R 33

if 33 is the number of the indexed post you want to reply to.  

#### NEW

Displays only the new posts in the stream since your last visit.

`ayadn --new timeline`

`ayadn -n -tl`

#### RAW

Displays the raw response from the App.net API instead of the formatted Ayadn output. For debugging and learning purposes.  

`ayadn --raw timeline`

`ayadn -x -tl`

#### EXTRACT

Extracts all links from posts resulting of a search by word(s) or by hashtag.

`ayadn tag --extract instagram`

`ayadn -t -e instagram`

`ayadn search --extract ruby gem`  

`ayadn -s -e ruby gem`  

## GLOBAL

Display the 'Global stream'.

`ayadn global`

`ayadn -gl`

Although the 'Global stream' is nowadays infested with spammers, it remains a fantastic source to find new people to interact with.

Ayadn helps you in that task with the [blacklist](#blacklist) command, which allows you to mute posters _per client name_, obliterating suddenly most of the bots and feeds.

You may also want to read the Conversations stream, which contains only posts leading to conversation threads.  

## CHECKINS

Display the 'Checkins stream'.

Ayadn will show any available geolocation data for these posts.

`ayadn checkins`

`ayadn -ck`

## CONVERSATIONS

Display the 'Conversations stream'.

This is a stream of posts that lead to [conversations](#convo) with real people.

`ayadn conversations`

`ayadn -cq`

## TRENDING

Display the 'Trending stream'.

This is a stream of trending posts.

`ayadn trending`

`ayadn -tr`

## MENTIONS

Display posts containing a mention of @username.

`ayadn mentions @ericd`

`ayadn -m @ericd`  

You can get your own mentions stream by using *me* instead of *@username*:

`ayadn -m me`

Don't forget that like most streams, Mentions is [scrollable](#scroll): very convenient to know at a glance if we got something new from our friends!

## POSTS

Show the posts of a specific user.

`ayadn userposts @ericd`

`ayadn -up @ericd`

You can get your own posts by using *me* instead of *@username*:

`ayadn -up me`

## MESSAGES

Show messages in a [channel](#channels).

`ayadn messages 46217`

`ayadn -ms 46217`

You can replace the channel id with its alias if you previously [defined](#alias) one:

`ayadn -ms mychannelalias`  

## WHATSTARRED

Show posts starred by a specific user.

`ayadn whatstarred @ericd`

`ayadn -was @ericd`

You can get your own stars by using *me* instead of *@username*:

`ayadn -was me`

## CONVO

Show the conversation thread around a specific post.

`ayadn convo 23362788`

`ayadn -co 23362788`

## HASHTAG

Show recent posts containing #HASHTAG(s).

`ayadn hashtag nowplaying`

`ayadn -t nowplaying`

`ayadn -t nowplaying rock`

## SEARCH

Show recents posts containing WORD(s).

`ayadn search ruby`

`ayadn -s ruby`

`ayadn -s ruby json api`

## RANDOM

Show series of random posts from App.net. Just for fun :)

`ayadn random`

`ayadn -rnd`  

## USER INFO

Show informations about a user.

`ayadn userinfo @ericd`

`ayadn -ui @ericd`

You can see your own info by using *me* instead of *@username*:

`ayadn -ui me`

## POST INFO

Show informations about a post.

`ayadn postinfo 23362788`

`ayadn -pi 23362788` 

# POSTING

This section is about posting to App.net.

## POST

Simple and fast way to post a short sentence/word to App.net.

`ayadn post Hello from Ayadn`

`ayadn -P Hello from Ayadn`

`ayadn -P @ericd hello Eric`

You have to put your text between single quotes if you're using punctuation:

`ayadn -P 'Hello from Ayadn, guys!'`

But remember you can't then use any `'` character!

**So you should rather use either the [write](#write) or the [auto](#auto-post) method for posting.**

## WRITE

Multi-line post to App.net.

This is the recommended way to post elaborate text to ADN:

`ayadn write`

`ayadn -W`

It will show you a prompt where you can type anything, including special characters and Markdown links.

Hit ENTER to create line breaks and paragraphs.

Cancel your post with CTRC-C or send it with CTRL-D.

Just type a @username at the beginning of your post if you want to mention a specific user, as you would in any other App.net client.  

## AUTO POST

Auto post every line of input.

The is the funniest way to post to ADN! :)  

`ayadn auto`

In this mode, each line you type (each time you hit ENTER!) is automatically posted to ADN.

You can type anything, including special characters and Markdown links, and of course mention anyone: the only thing you can't do from this mode is _replying_ to a post in a thread.

Hit CTRL+C to exit this mode at any moment.  

## REPLY

Reply to a specific post.

- You can reply by specifying the post id:

`ayadn reply 23362460`

`ayadn -R 23362460`

Ayadn will then show you the [write](#write) prompt.

If you reply to a post containing multiple mentions, your text will be inserted between the leading mention and the other ones.

- You can also reply to the *index* of the post instead of its *id* _if you used the '--index' or '-i' option_ when previously viewing a stream:

`ayadn -R 3`  

## PM (PRIVATE MESSAGE)

Send a private message to a specific user.

`ayadn pm @ericd`

Ayadn will then show you the [write](#write) prompt.  

## SEND

Send a message to an App.net CHANNEL.

`ayadn send 46217`

`ayadn -C 46217`

Ayadn will then show you the [write](#write) prompt.

If you've already created an [alias](#alias) for the channel, you can post to it with:

`ayadn send mychannelalias`

`ayadn -C mychannelalias`

# ACTIONS

This section is about available actions like follow, repost, etc.

## DELETE

Delete a post.

`ayadn delete 23365251`

`ayadn -D 23365251`

## REPOST

Repost a post.

`ayadn repost 23365251`

`ayadn -O 23365251`

## UNREPOST

Unrepost a post.

`ayadn unrepost 23365251`

`ayadn -UR 23365251`

## STAR

Star a post.

`ayadn star 23365251`

`ayadn -ST 23365251`

## UNSTAR

Unstar a post.

`ayadn unstar 23365251`

`ayadn -US 23365251`

## FOLLOW

Follow a user.

`ayadn follow @ericd`

`ayadn -FO @ericd`

## UNFOLLOW

Unfollow a user.

`ayadn unfollow @ericd`

`ayadn -UF @ericd`

## MUTE

Mute a user.

`ayadn mute @spammer`

`ayadn -MU @spammer`

## UNMUTE

Unmute a user.

`ayadn unmute @spammer`

`ayadn -UM @spammer`

## BLOCK

Block a user (same as [mute](#mute) but also prevents the blocked user to [follow](#follow) you).

`ayadn block @spammer`

`ayadn -BL @spammer`

## UNBLOCK

Unblock a user.

`ayadn unblock @spammer`

`ayadn -UB @spammer`

## DOWNLOAD

Download a file from your App.net storage (any file posted with other ADN clients).

`ayadn download 23344556`

`ayadn -df 23344556`

# LISTS

This section is about getting lists from App.net.

## FOLLOWERS

List followers of a user.

`ayadn followers @ericd`

`ayadn -fwr @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwr me`

## FOLLOWINGS

List the users a user is following.

`ayadn followings @ericd`

`ayadn -fwg @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwg me`

## CHANNELS

List your active App.net channels.

`ayadn channels`

`ayadn -ch`

## INTERACTIONS

Shows a short reminder of your recent App.net activity.

`ayadn interactions`

`ayadn -int`

## WHOREPOSTED

List users who reposted a post.

`ayadn whoreposted 22790201`

`ayadn -wor 22790201`

## MUTED

List the users you muted.

`ayadn muted`

`ayadn -mtd`

## BLOCKED

List the users you blocked.

`ayadn blocked`

`ayadn -bkd`

## SETTINGS

List current Ayadn settings.

`ayadn settings`

`ayadn -sg`

## FILES

List the files in your App.net storage.

`ayadn files`

`ayadn -fl`

List them all:

`ayadn files -a`

`ayadn -fl -a`

# TOOLS

This section is about specific Ayadn tools.

## AUTHORIZE

Authorize Ayadn for a specific user account.

`ayadn authorize`

`ayadn -auth`

Ayadn will give you a link leading to the official App.net registration page.

After your successful login, you will be redirected to the Ayadn authorization page.

Copy the code (token) you will find there and paste it into Ayadn: a new user will be created and automatically logged in.  

## SWITCH

Switch between your authorized accounts.

`ayadn switch @ericd`

`ayadn switch @otheraccount`

Alternative syntax:

`ayadn -@ ericd`

`ayadn -@ otheraccount`

List your authorized accounts:

`ayadn switch -l`

`ayadn -@ -l`

## BLACKLIST

The blacklist is a list of users, clients and hashtags that you don't want to ever be displayed.

Available subcommands: add, remove, import, list.

This is different from the 'mute a user' feature of the App.net API: blacklist works locally and is specific to each account.

Blacklist a client (example: IFTTT) and posts that are posted with this client won't appear in the streams.

This is a way of creating "bot-free" streams: the more bots you add to this list, the more humans you see.

Blacklist a hashtag and you will free yourself from this annoying trend you can't stand.

Blacklist a user and you won't even see posts by other users mentioning the user you blacklisted!

Oh, and you can import blacklist databases from other accounts, too.

### ADD

Adds an item to your blacklist.

Available items: client, hashtag, mention.

`ayadn blacklist add mention @shmuck`

Add a mention:

`ayadn -K add mention @shmuck`

Add a client:

`ayadn -K add client IFTTT`

Add a hashtag:

`ayadn -K add hashtag twitter`

### REMOVE

Removes an item from your blacklist.

Available items: client, hashtag, mention.

`ayadn blacklist remove mention @shmuck`

Remove a mention:

`ayadn -K remove mention @shmuck`

Remove a client:

`ayadn -K remove client IFTTT`

Remove a hashtag:

`ayadn -K remove hashtag twitter`

### LIST

List all items in your blacklist.

`ayadn blacklist list`

`ayadn -K list`

### IMPORT

Import a blacklist database in the current account.

`ayadn blacklist import '/Users/blah/backups/blacklist.db'`

`ayadn -K import '/Users/blah/backups/blacklist.db'`

## ALIAS

Aliases are names you give to channels for an easier access.

Available subcommands: create, delete, list, import.

Example: you're a [Paste-App](http://paste-app.net/) user and your personal Paste-App channel is 46216.

Instead of getting this channel's messages with `ayadn -ms 46216` you can create an alias:

`ayadn alias create 46216 pasteapp`

or

`ayadn -A create 46216 pasteapp`

Then you can access this channel with `ayadn -ms pasteapp`, as words are easier to remember than numbers.

### CREATE

Create an alias for a channel.

`ayadn alias create 46216 pasteapp`

`ayadn -A create 46216 pasteapp`

### DELETE

Delete a channel alias.

`ayadn alias delete pasteapp`

`ayadn -A delete pasteapp`

### LIST

List all your channel aliases.

`ayadn alias list`

`ayadn -A list`

### IMPORT

Import a previously backed-up list of aliases.

`ayadn alias import '/Users/blah/backups/aliases.db'`

`ayadn -A import '/Users/blah/backups/aliases.db'`

## SET

The 'set' commands allows you to configure some Ayadn parameters.

`ayadn set color mentions blue`

You can get a list of configurable parameters with `ayadn -sg`.

Examples:

`ayadn set color username green`

`ayadn set color mentions yellow`

`ayadn set counts default 30`

`ayadn set counts search 100`

`ayadn set timeline directed false`

`ayadn set show_real_name false`

`ayadn set show_date false`

`ayadn set backup auto_save_sent_posts true`

`ayadn set scroll timer 1.5`

To reset the configuration to default values:

`ayadn set defaults`


# EXTRAS

This section is about specific Ayadn extras.

## PIN

Export a post's link and text, with tags, to your Pinboard account.

`ayadn pin 22790201 Ayadn gem update`

`ayadn pin 26874913 duel swords france`

## NOWPLAYING

Post what you're listening to!

Only works on Mac OS X with iTunes.

`ayadn nowplaying`

`ayadn -np`

Ayadn will grab information from iTunes, format it, insert the *#nowplaying* hashtag then ask for your confirmation before posting it.

