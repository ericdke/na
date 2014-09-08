# FOLLOWERS

List followers of a user.

`ayadn followers @ericd`

`ayadn -fwr @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwr me`

# FOLLOWINGS

List the users a user is following.

`ayadn followings @ericd`

`ayadn -fwg @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwg me`

# CHANNELS

List all your active App.net channels.

`ayadn channels`

`ayadn -ch`

Retrieve a unique channel, or specific channel(s), with option `--id`:

`ayadn -ch --id 55123`

`ayadn -ch --id 55123 34678 988776`

Display raw response with option `-x`:

`ayadn -ch -x`

`ayadn -ch -x --id 55123`  

# INTERACTIONS

Shows a short reminder of your recent App.net activity.

`ayadn interactions`

`ayadn -int`

# WHOREPOSTED

List users who reposted a post.

`ayadn whoreposted 22790201`

`ayadn -wor 22790201`

# MUTED

List the users you muted.

`ayadn muted`

`ayadn -mtd`

# BLOCKED

List the users you blocked.

`ayadn blocked`

`ayadn -bkd`

# SETTINGS

List current Ayadn settings.

`ayadn settings`

`ayadn -sg`

# FILES

List the files in your App.net storage.

`ayadn files`

`ayadn -fl`

List them all:

`ayadn files -a`

`ayadn -fl -a`

## OPTIONS

### LIST

You can reverse the default lists order with a `set` command:

`ayadn set list reverse false`

(defaults to true since Ayadn version 1.7.3)

### TABLE

You can change the width of the lists table if the default size doesn't fit well in your terminal:

`ayadn set table width 80`

(min: 60, max: 90, default: 75)
