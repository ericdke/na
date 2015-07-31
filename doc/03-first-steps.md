# FIRST STEPS

## AUTHORIZE

You have to give Ayadn the authorization to use your App.net account. 

Just run 

`ayadn -auth` 

to register a new user.  

## ACCOUNTS

Ayadn supports multiple accounts.

Register a new user with 

`ayadn -auth` 

at any moment.

You can then switch between accounts:

`ayadn switch @ericd` 

Shortcut: 

`ayadn -@ ericd`  

You can also unauthorize a user with or without deleting its folders:

`ayadn unauthorize @ericd`

Shortcut: 

`ayadn -UA -D @ericd`

## DATA

All Ayadn files and folders are created in your 'home' folder. 

```
  /Users/user/ayadn/
  ├── accounts.sqlite
  /Users/user/ayadn/ericd
  ├── auth
  │   └── token
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

Each authorized account has its set of folders, a config file and a database.

If you're not sure if your config file is up to date or properly filled and you want to benefit from the new options in Ayadn, run 

`ayadn set defaults` 

and it will create a brand new file with default values.  

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

## SHORTCUTS

Examples in the documentation include the complete command followed by its shortcut version. 

Of course, using Ayadn is much faster with the shortcut commands.

If you're like me, you'll even want to create aliases in bash/zsh or TextExpander snippets for the combinations of Ayadn commands and options you use the most...  

## EXAMPLES

Just a few examples of commands to give you a hint at the flexible syntax.

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
