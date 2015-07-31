# FOLLOWERS

List followers of a user.

`ayadn followers @ericd`

`ayadn -fwr @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwr me`

Sort the list by username:

`ayadn -fwr -u me`

Sort the list by name:

`ayadn -fwr -n me`

Sort the list by posts/day:

`ayadn -fwr -d me`

Sort the list by total posts:

`ayadn -fwr -p me`

Reverse the list order:

`ayadn -fwr -r me`

`ayadn -fwr -u -r me`

Force compact view (works with all compatible listing views):

`ayadn -fwr -k me`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -fwr --cache me`

`ayadn -fwr --again me`

*Note: `--cache` and `--again` don't have shortcuts.*

# FOLLOWINGS

List the users a user is following.

`ayadn followings @ericd`

`ayadn -fwg @ericd`

You can see your own list by using *me* instead of *@username*:

`ayadn -fwg me`

Sort the list by username:

`ayadn -fwg -u me`

Sort the list by name:

`ayadn -fwg -n me`

Sort the list by posts/day:

`ayadn -fwg -d me`

Sort the list by total posts:

`ayadn -fwg -p me`

Reverse the list order:

`ayadn -fwg -r me`

`ayadn -fwg -u -r me`

Show the last post of each user you're following:

`ayadn -fwg -l me`

Sort it by last post date:

`ayadn -fwg -l -t me`

*Note: `-t` is ignored outside of 'last posts'. Other options are compatible with 'last posts' except `-r`.*

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -fwg --cache me`

`ayadn -fwg --again me`

*Note: `--cache` and `--again` don't have shortcuts.*

# CHANNELS

List all your active App.net channels.

`ayadn channels`

`ayadn -ch`

Retrieve a unique channel, or specific channel(s), with option `--id`:

`ayadn -ch --id 55123`

`ayadn -ch --id 55123 34678 988776`

Retrieve only your broadcast channel(s):

`ayadn -ch --broadcasts`

Retrieve only your private messages channel(s):

`ayadn -ch --messages`

Retrieve only your patter room channel(s):

`ayadn -ch --patter`

Retrieve all channel(s) except broadcasts, messages or patter:

`ayadn -ch --other`  

# INTERACTIONS

Shows a short reminder of your recent App.net activity.

`ayadn interactions`

`ayadn -int`

# WHOREPOSTED

List users who reposted a post.

`ayadn whoreposted 22790201`

`ayadn -wor 22790201`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -wor --cache 22790201`

`ayadn -wor --again 22790201`

*Note: `--cache` and `--again` don't have shortcuts.*

# WHOSTARRED

List users who starred a post.

`ayadn whostarred 22790201`

`ayadn -wos 22790201`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -wos --cache 22790201`

`ayadn -wos --again 22790201`

*Note: `--cache` and `--again` don't have shortcuts.*

# MUTED

List the users you muted.

`ayadn muted`

`ayadn -mtd`

Sort the list by username:

`ayadn -mtd -u`

Sort the list by name:

`ayadn -mtd -n`

Sort the list by posts/day:

`ayadn -mtd -d`

Sort the list by total posts:

`ayadn -mtd -p`

Reverse the list order:

`ayadn -mtd -r`

`ayadn -mtd -u -r`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -mtd --cache`

`ayadn -mtd --again`

*Note: `--cache` and `--again` don't have shortcuts.*

# BLOCKED

List the users you blocked.

`ayadn blocked`

`ayadn -bkd`

Sort the list by username:

`ayadn -bkd -u`

Sort the list by name:

`ayadn -bkd -n`

Sort the list by posts/day:

`ayadn -bkd -d`

Sort the list by total posts:

`ayadn -bkd -p`

Reverse the list order:

`ayadn -bkd -r`

`ayadn -bkd -u -r`

You can cache the results if you want to replay the same request again later and obtain the same results instantly:

`ayadn -bkd --cache`

`ayadn -bkd --again`

*Note: `--cache` and `--again` don't have shortcuts.*

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

You can permanently reverse the ADN default list order with a `set` command:

`ayadn set formats list reverse false`

(defaults to true since Ayadn version 1.7.3)

### TABLE

You can change the width of the lists table if the default size doesn't fit well in your terminal:

`ayadn set formats table width 70`

(min: 60, max: 90, default: 75)

And also enable/disable the tables borders:

`ayadn set formats table borders false`

(default: true)
