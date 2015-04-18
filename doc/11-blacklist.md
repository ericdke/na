# BLACKLIST

The blacklist is a list of users, clients and hashtags that you don't want to be displayed anywhere in Ayadn.

Available subcommands: add, remove, list.

This is different from the 'mute a user' feature of the App.net API: blacklist works locally and is specific to each Ayadn account.

Blacklist a client (example: IFTTT) and posts that are posted with this client won't appear in the streams.

This is a way of creating "bot-free" streams: the more bots you add to this list, the more humans you see.

Blacklist a hashtag and you will free yourself from this annoying trend you can't stand.

Blacklist a user and, well, never see this user again.

Blacklist a mention and you won't even see posts by other users mentioning the user you blacklisted!

You can even blacklist a single keyword if you *really* don't want to see something.

*Since Ayadn 2.0, adding and removing to/from the blacklist takes immediately effect and is shared with other Ayadn instances launched by the same user.*

## ADD

Adds an item to your blacklist.

Available items: client, hashtag, user, mention, word.

`ayadn blacklist add mention @shmuck`

Add a user:

`ayadn -K add user @shmuck`

Add a mention of a user:

`ayadn -K add mention @shmuck`

Add a client:

`ayadn -K add client IFTTT`

Add a hashtag:

`ayadn -K add hashtag twitter`

Add a keyword:

`ayadn -K add word poo`

## REMOVE

Removes an item from your blacklist.

Available items: client, hashtag, user, mention, word.

`ayadn blacklist remove mention @shmuck`

Remove a user:

`ayadn -K remove user @shmuck`

Remove a mention:

`ayadn -K remove mention @shmuck`

Remove a client:

`ayadn -K remove client IFTTT`

Remove a hashtag:

`ayadn -K remove hashtag twitter`

Remove a keyword:

`ayadn -K remove word poo`

## LIST

List all items in your blacklist.

`ayadn blacklist list`

`ayadn -K list`  

## MULTIPLE TARGETS

You can add/remove several elements to/from the blacklist at once.

(For usernames, '@' prefix will automatically be added if missing.)  

`ayadn -K add user shmuck jerk mrspammer`

`ayadn -K add mention shmuck jerk mrspammer`

`ayadn -K add client ifttt pourover twitterfeed`

`ayadn -K add hashtag twitter facebook instagram`
