# FIRST STEPS

## AUTHORIZE

You have to give Ayadn the authorization to use your App.net account. 

Just run 

`ayadn -auth` 

or 

`ayadn -AU` 

to register a new user.  

## ACCOUNTS

Ayadn supports multiple accounts.

Register a new user with 

`ayadn -AU` 

at any moment.

You can then switch between accounts:

`ayadn switch @ericd` 

or 

`ayadn -@ ericd`  

You can also unauthorize a user with or without deleting its folders:

`ayadn unauthorize @ericd`

`ayadn -UA -D @ericd`

## DATA

All Ayadn files and folders are created in your 'home' folder. 

On Mac OS X, it looks like this:

```
  /Users/user/ayadn/
  ├── accounts.sqlite
  /Users/user/ayadn/ericd
  ├── auth
  │   └── token
  ├── backup
  ├── config
  │   ├── api.json
  │   ├── config.yml
  │   └── version.yml
  ├── db
  │   └── ayadn.sqlite
  ├── downloads
  ├── lists
  ├── log
  │   └── ayadn.log
  ├── messages
  └── posts
```

Each authorized account has its set of folders and databases.

If you're not sure if your config file is up to date or properly filled and you want to benefit from the new options in Ayadn, run 

`ayadn set defaults` 

and it will create a brand new file with optimal values.  

## HELP

`ayadn` 

shows a list of available commands.  

`ayadn help COMMAND` 

shows the instructions and available options for a specific command. 

Examples:  

`ayadn help post`  

`ayadn help timeline`  

`ayadn help blacklist`  

And for the subcommands:

`ayadn blacklist help delete`

`ayadn alias help create`  

It also works with the shortcuts:

`ayadn help -tl`  

`ayadn help -K` 

`ayadn -K help delete`

`ayadn -A help create`  


## SHORTCUTS

Most examples in the documentation include the 'complete' command followed by the 'shortcut' command. 

Of course, using Ayadn is much faster with the shortcut commands.

If you're like me, you'll even want to create aliases in bash/zsh or TextExpander snippets for the combinations of Ayadn commands and options you use the most...  


## EXAMPLES

Just a few examples to give you a hint at the flexible syntax.

Complete:    

`ayadn timeline`

`ayadn checkins --count=10 --index`

`ayadn global --scroll`

`ayadn userposts @ericd`

`ayadn post 'Hello guys!'`

`ayadn write`

`ayadn reply 23362460`

`ayadn convo 23362788`

`ayadn search movies hollywood`

`ayadn follow @ericd`  

Shortcuts:  

`ayadn -tl`

`ayadn -ck -c10 -i`

`ayadn -gl -s`

`ayadn -up @ericd`

`ayadn -P 'Hello guys!'`

`ayadn -W`

`ayadn -R 23362460`

`ayadn -co 23362788`

`ayadn -s movies hollywood`

`ayadn -FO @ericd` 
