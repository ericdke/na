# DELETE

Delete a post.

`ayadn delete 23365251`

`ayadn -D 23365251`

Accepts several post ids:

`ayadn -D 23365251 23365252 23365253`  

Note: since Ayadn 2.0, posts index resolution is activated by default for posts ids from 1 to 200. Add option `--force` to ignore index and retrieve the actual old post if needed.

This absolute range from 1 to 200 for indexed posts exists because indexed posts aren't available in scroll views, so an index will never be greater than 200 (which is the ADN number of posts per request limit).

*Note: this "indexed" concept is also active by default for all posts commands (repost, star, reply, etc).*

# DELETE_M

Delete a private message. 

You have to specify channel id (or alias) then message number.

`ayadn delete_m 42666 3365251`

`ayadn -DM 42666 3365251`

`ayadn -DM my_alias 3365251`

Accepts several message ids:

`ayadn -DM my_alias 23365251 23365252 23365253`  

# REPOST

Repost a post.

`ayadn repost 23365251`

`ayadn -O 23365251`

Accepts several post ids:

`ayadn -O 23365251 23365252 23365253`

# UNREPOST

Unrepost a post.

`ayadn unrepost 23365251`

`ayadn -UR 23365251`

Accepts several post ids:

`ayadn -UR 23365251 23365252 23365253`

# STAR

Star a post.

`ayadn star 23365251`

`ayadn -ST 23365251`

Accepts several post ids:

`ayadn -ST 23365251 23365252 23365253`

# UNSTAR

Unstar a post.

`ayadn unstar 23365251`

`ayadn -US 23365251`

Accepts several post ids:

`ayadn -US 23365251 23365252 23365253`

# FOLLOW

Follow a user.

`ayadn follow @ericd`

`ayadn -FO @ericd`

Accepts several users:

`ayadn -FO @ericd @ayadn @adnapi`

# UNFOLLOW

Unfollow a user.

`ayadn unfollow @ericd`

`ayadn -UF @ericd`

Accepts several users:

`ayadn -UF @ericd @ayadn @adnapi`

# MUTE

Mute a user.

`ayadn mute @spammer`

`ayadn -MU @spammer`

Accepts several users:

`ayadn -MU @spammer @thickhead`

# UNMUTE

Unmute a user.

`ayadn unmute @spammer`

`ayadn -UM @spammer`

Accepts several users:

`ayadn -UM @spammer @thickhead`

# BLOCK

Block a user (same as mute but also prevents the blocked user to follow you).

`ayadn block @spammer`

`ayadn -BL @spammer`

Accepts several users:

`ayadn -BL @spammer @thickhead`

# UNBLOCK

Unblock a user.

`ayadn unblock @spammer`

`ayadn -UB @spammer`

Accepts several users:

`ayadn -UB @spammer @thickhead`

# DOWNLOAD

Download a file from your App.net storage (any file posted with any ADN client).

`ayadn download 23344556`

`ayadn -df 23344556`

# PIN

Export a post's url, text and link(s) to your Pinboard account and add optional tags.

`ayadn pin 22790201 Ayadn Ruby dev`

`ayadn pin 26874913 duel swords france history`

# UPDATE

- Update your user profile

`ayadn --update --bio`

`ayadn -U --bio`

`ayadn -U --name`

`ayadn -U --twitter`

`ayadn -U --blog`

`ayadn -U --web`

`ayadn -U --avatar ~/Pics/myface.jpg`

*Avatar: the uploaded image will be cropped to square and must be smaller than 1 MB. The optimal size is 200×200 pixels.*

`ayadn -U --cover ~/Pics/mycats.jpg`

*Cover: the uploaded image must be at least 960 pixels wide and less than 4 MB in size.*

- Use option `--delete` or `-D` to delete the field

`ayadn --update --bio --delete`

`ayadn -U --bio -D`

`ayadn -U --twitter -D`

`ayadn -U --blog -D`

`ayadn -U --web -D`
