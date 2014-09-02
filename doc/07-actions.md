# DELETE

Delete a post.

`ayadn delete 23365251`

`ayadn -D 23365251`

# DELETE MESSAGE

Delete a message. 

You have to specify channel id (or alias) then message number.

`ayadn delete_m 42666 3365251`

`ayadn -DM 42666 3365251`

`ayadn -DM my_alias 3365251`

# REPOST

Repost a post.

`ayadn repost 23365251`

`ayadn -O 23365251`

# UNREPOST

Unrepost a post.

`ayadn unrepost 23365251`

`ayadn -UR 23365251`

# STAR

Star a post.

`ayadn star 23365251`

`ayadn -ST 23365251`

# UNSTAR

Unstar a post.

`ayadn unstar 23365251`

`ayadn -US 23365251`

# FOLLOW

Follow a user.

`ayadn follow @ericd`

`ayadn -FO @ericd`

# UNFOLLOW

Unfollow a user.

`ayadn unfollow @ericd`

`ayadn -UF @ericd`

# MUTE

Mute a user.

`ayadn mute @spammer`

`ayadn -MU @spammer`

# UNMUTE

Unmute a user.

`ayadn unmute @spammer`

`ayadn -UM @spammer`

# BLOCK

Block a user (same as mute but also prevents the blocked user to follow you).

`ayadn block @spammer`

`ayadn -BL @spammer`

# UNBLOCK

Unblock a user.

`ayadn unblock @spammer`

`ayadn -UB @spammer`

# DOWNLOAD

Download a file from your App.net storage (any file posted with other ADN clients).

`ayadn download 23344556`

`ayadn -df 23344556`

# PIN

Export a post's link and text, with tags, to your Pinboard account.

`ayadn pin 22790201 Ayadn gem update`

`ayadn pin 26874913 duel swords france`

# UPDATE

Update your user profile.

Use option `--delete` or `-D` to delete the field.

`ayadn --update --bio`

`ayadn -U --bio`

`ayadn --update --bio --delete`

`ayadn -U --bio -D`

`ayadn -U --name`

`ayadn -U --twitter`

`ayadn -U --twitter -D`

`ayadn -U --blog`

`ayadn -U --blog -D`

`ayadn -U --web`

`ayadn -U --web -D`

`ayadn -U --avatar ~/Pics/myface.jpg`

Avatar: the uploaded image will be cropped to square and must be smaller than 1 MB. The optimal size is 200×200 pixels.

`ayadn -U --cover ~/Pics/mycats.jpg`

Cover: the uploaded image must be at least 960 pixels wide and less than 4 MB in size.
