# TIMELINE

Display your main timeline.

This is also called the 'Unified stream': it regroups the posts of people you follow and the posts mentioning you.

`ayadn timeline`

`ayadn -tl`

## AVAILABLE OPTIONS

### SCROLL

Scroll your timeline with:

`ayadn timeline --scroll`

`ayadn -tl -s`  

#### SCROLL REFRESH

*Read this only if you want to launch several scroll streams at once*

Ayadn pulls the stream every 3 seconds by default. It means you can launch up to 3 scroll streams at a time _per account_ if you want. 

To launch even more streams at the same time, increment the timer by one second for each stream. 

Example: to launch 10 streams, set the timer to 12 seconds *before launching the streams* with `ayadn set scroll timer 12`.

On the contrary, you can bring that value down to 1 second if you're using only _one_ scroll stream per account at a time.

App.net accepts 5000 requests per hour per account maximum. If Ayadn ends up making too many requests to ADN, it will display an alert message with instructions, then it will exit.

### COUNT

Ayadn displays a certain number of posts by default when you request a stream.

With the *count* option, you can set a specific value for each request:

`ayadn timeline --count=10`

`ayadn -tl -c10`

The maximum value is 200 for any stream.

### INDEX

Shows an index instead of the posts ids.

`ayadn timeline --index`

`ayadn -tl -i`  

This is particularly useful if you're using Ayadn to *reply* to conversations.

Copy/pasting the post id can be tedious at times, and anyway it's faster to glance at a short number and use it immediately.

Example:

`ayadn -tl -i`

`ayadn -R 33`

if 33 is the number of the indexed post you want to reply to. 

Note: since Ayadn 2.0, posts index resolution is activated by default for posts ids from 1 to 200. Add option `--force` to ignore index and retrieve the actual old post if needed.

This absolute range from 1 to 200 for indexed posts exists because indexed posts aren't available in scroll views, so an index will never be greater than 200 (which is the ADN number of posts per request limit).

### NEW

Displays only the new posts in the stream since your last visit.

`ayadn timeline --new`

`ayadn -tl -n`

### RAW

Displays the raw response from the App.net API instead of the formatted Ayadn output.  

`ayadn timeline --raw`

`ayadn -tl -x`

*Note: when `-x` is used, visual layout options are ignored. This allows redirecting the output to a file, for example.*

### EXTRACT

Extracts all links from posts.

`ayadn hashtag --extract instagram`

`ayadn -t -e instagram`

`ayadn search --extract ruby gem`  

`ayadn -s -e ruby gem`  

`ayadn whatstarred @ericd -e`

`ayadn -was -e ericd`

### FORCE

Force view blacklisted/muted/blocked user's posts with `-f` option. 

`ayadn -gl -f`

`ayadn -gl -s -f`

Differences will occur due to ADN policy:

- Global stream: temporarily disables you user token (so your muted/blocked preferences don't apply), the NiceRank filter, and the Blacklist databases

- User's posts and Post infos: temporarily disables you user token and the Blacklist databases

- Other streams, search, tags: temporarily disables the Blacklist databases

### COMPACT

Removes the line-breaks when possible, and forces the view to be "compact".

Option is `-k` (or `--compact`):

`ayadn global --scroll --compact`

`ayadn timeline --index --count=200 --compact`

`ayadn userposts me --name --compact`

or

`ayadn -gl -s -k`

`ayadn -tl -i -c200 -k`

`ayadn -up me -n -k`

*Works with all compatible views, streams and lists.*

Set it permanently with:

`ayadn set timeline compact true`

*Tip: you may want to change colors to create visual marks between posts if you choose the compact view by default, i.e. setting the whole header to the same color (post id, username, name, etc).*

# GLOBAL

Display the 'Global stream'.

`ayadn global`

`ayadn -gl`

Although the 'Global stream' is nowadays infested with spammers, it remains a fantastic source to find new people to interact with.

Ayadn helps you in that task with two tools:

- the *blacklist* command, which allows you to mute posters per client name, hashtag or mention, obliterating the unwanted posts

- the *NiceRank* filter, which allows you to filter spammers out


# CHECKINS

Display the 'Checkins stream'.

Ayadn will show any available geolocation data for these posts.

`ayadn checkins`

`ayadn -ck`

# CONVERSATIONS

Display the 'Conversations stream'.

This is a stream of posts that lead to *conversations* with real people.

`ayadn conversations`

`ayadn -cq`

# TRENDING

Display the 'Trending stream'.

This is a stream of trending posts.

`ayadn trending`

`ayadn -tr`

# PHOTOS

Display the 'Photos stream'.

This is a stream of posts including a picture.

`ayadn photos`

`ayadn -ph`  

# MENTIONS

Display posts containing a mention of @username.

`ayadn mentions @ericd`

`ayadn -m @ericd`  

You can get your own mentions stream by using *me* instead of *@username*:

`ayadn -m me`

Like most streams, Mentions is *scrollable*: very convenient to know at a glance if we got something new from our friends!

# POSTS

Show the posts of a specific user.

`ayadn userposts @ericd`

`ayadn -up @ericd`

You can get your own posts by using *me* instead of *@username*:

`ayadn -up me`

# MESSAGES

Show messages in a *channel*.

`ayadn messages 46217`

`ayadn -ms 46217`

You can replace the channel id with its alias if you previously defined one:

`ayadn -ms mychannelalias`  

By default, Ayadn will mark the channel as read after running the `messages` command.

You can pass an option to avoid this for the time of the command:

`ayadn -ms -z 46217`

Or you can set it off permanently:

`ayadn set marker messages false`

Since version 1.7.7, Ayadn shows the full oembed links in messages if any. As these links can be quite long and complex, you can remove them from the view if you want with `ayadn set channels links false`.  

# UNREAD MESSAGES

Show *all* unread messages.

`ayadn messages_unread`

`ayadn -pmu`

Ayadn will mark all your PM channels as read after running this command.

You can pass an option to avoid this for the time of the command:

`ayadn -pmu -z`

Or you can set it off permanently:

`ayadn set marker messages false`  

# WHATSTARRED

Show posts starred by a specific user.

`ayadn whatstarred @ericd`

`ayadn -was @ericd`

You can get your own stars by using *me* instead of *@username*:

`ayadn -was me`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -was --cache me`

`ayadn -was --again me`

*Note: `--cache` and `--again` don't have shortcuts.*

# CONVO

Show the conversation thread around a specific post.

`ayadn convo 23362788`

`ayadn -co 23362788`

# HASHTAG

Show recent posts containing #HASHTAG(s).

`ayadn hashtag nowplaying`

`ayadn -t nowplaying`

`ayadn -t nowplaying rock`

# SEARCH

Show recents posts containing WORD(s).

`ayadn search ruby`

`ayadn search ruby json api`

## Search in messages, including PMs

You can now search for WORD(S) in the messages of a channel, for example all PMs between you and @username.

You have to specify a channel id (or an alias).

```
ayadn search --messages 24573 'meet me at'
ayadn search --messages my_alias 'meet me at'
```

If you don't know what are your subscribed channels ids, discover them with `ayadn -ch`, then you can also set aliases with `ayadn -A create 24573 my_alias` to remember the names easily.

## Look for users

Look for App.net users by searching WORD(S) in their bio/description.

`ayadn search --users coffee food`

Returns a detailed view of each user's profile and informations.

## Discover channels

Search for App.net channels by searching WORD(S) in their description.

`ayadn search --channels podcast ios`

(This one operation may *sometimes* be long to execute if there's a lot of results.)

If the channel (let's say 24573) is public, you can read its messages with `ayadn -ms 24573` or `ayadn -ms my_alias`.

## Search ADN annotations

For the developers -or the adventurous-, there's a command to search for annotations types.

`ayadn search --annotations net.app.ohai.location`

# USER INFO

Show informations about a user.

`ayadn userinfo @ericd`

`ayadn -ui @ericd`

You can see your own info by using *me* instead of *@username*:

`ayadn -ui me`

# POST INFO

Show informations about a post.

`ayadn postinfo 23362788`

`ayadn -pi 23362788` 

# RANDOM

Show series of random posts from ADN. Just for fun :)

`ayadn random`

`ayadn -rnd`  
