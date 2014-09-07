# POST

Simple and fast way to post a short sentence/word to App.net.

`ayadn post Hello from Ayadn`

`ayadn -P Hello from Ayadn`

`ayadn -P @ericd hello Eric`

You have to put your text between single quotes if you're using punctuation:

`ayadn -P 'Hello from Ayadn, guys!'`

But remember you can't then use any `'` character!

**So you should rather use either the _write_ or the _auto_ method for posting.**

# WRITE

Multi-line post to App.net.

This is the recommended way to post elaborate text to ADN:

`ayadn write`

`ayadn -W`

It will show you a prompt where you can type anything, including special characters and Markdown links.

Hit ENTER to create line breaks and paragraphs.

Cancel your post with CTRC-C or send it with CTRL-D.

Just type a @username at the beginning of your post if you want to mention a specific user, as you would in any other App.net client.  

# AUTO POST

Auto post every line of input.

The is the funniest way to post to ADN! :)  

`ayadn auto`

In this mode, each line you type (each time you hit ENTER!) is automatically posted to ADN.

You can type anything, including special characters and Markdown links, and of course mention anyone: the only thing you can't do from this mode is _replying_ to a post in a thread.

Hit CTRL+C to exit this mode at any moment.  

# REPLY

Reply to a specific post.

- You can reply by specifying the post id:

`ayadn reply 23362460`

`ayadn -R 23362460`

Ayadn will then show you the *write* prompt.

If you reply to a post containing multiple mentions, your text will be inserted between the leading mention and the other ones.

- You can also reply to the *index* of the post instead of its *id* _if you used the '--index' or '-i' option_ when previously viewing a stream:

`ayadn -R 3`  

If you reply to a reposted post, Ayadn will reply to the original post, complying with the ADN guidelines.

However, you can reply to the reposted post with the `--noredirect` option:

`ayadn -R --noredirect 23344556`

`ayadn -R -n 23344556`  


# PM (PRIVATE MESSAGE)

Send a private message to a specific user.

`ayadn pm @ericd`

Ayadn will then show you the *write* prompt.  

# SEND

Send a message to an App.net CHANNEL.

`ayadn send 46217`

`ayadn -C 46217`

Ayadn will then show you the *write* prompt.

If you've already created an [alias](#alias) for the channel, you can post to it with:

`ayadn send mychannelalias`

`ayadn -C mychannelalias`

# EMBED PICTURES

You can embed one or several pictures in a post (with `post`, `write`, `reply` and `pm`).

Just add the `-E` (or `--embed`) option **at the end** of the command line, followed by one or several file paths separated by spaces.

Accepted file formats are `jpg`, `png` and `gif`.

Examples:

```
ayadn -P Meet my cat -E lolcat.jpg
ayadn -P "@ericd Hey, meet my pets" -E ~/lolcat.jpg ./doge.jpeg
ayadn -W -E ~/lolcat.png
ayadn -R 23362460 -E "Desktop/dancing lolcat.gif"
ayadn pm @ericd -E /users/dad/lol\'cat.JPG /users/mom/my\ doge.PNG
```  

# EMBED VIDEOS

You can embed a video hosted online in a post. Currently works with Youtube and Vimeo only.

Add the `-Y` option for Youtube or `-V` for Vimeo **at the end** of the command line, followed by the video URL.

Examples:

```
ayadn -P wave function -Y https://www.youtube.com/watch?v=Ei8CFin00PY
ayadn -P Elixir -V http://vimeo.com/103927232
ayadn -W -Y https://www.youtube.com/watch?v=Ei8CFin00PY
ayadn -R 23362460 -Y https://www.youtube.com/watch?v=Ei8CFin00PY
ayadn pm @ericd -Y https://www.youtube.com/watch?v=Ei8CFin00PY
```

Unfortunately, very few App.net clients treat video embedding properly. So I would advise to include the video URL in the text body anyway, for better compatibility.

# EMBED MOVIE POSTER

You can embed a movie poster in a normal post with option `-M`.

This is compatible with other options, eg embedding other images.

Warning: contrary to the `movie` command, this option doesn't check with the user if the movie is valid. The poster is retrieved from IMDb and is automatically embedded in the post.

Examples:

```
ayadn -P "I'll be back" -M terminator
ayadn -W -M truman show -E ~/Pics/my_face.jpg
ayadn -R 23362460 -M the dark knight
```  

