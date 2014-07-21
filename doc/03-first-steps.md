# FIRST STEPS

## AUTHORIZE

You have to give Ayadn the authorization to use your App.net account. 

Just run 

`ayadn authorize` 

or 

`ayadn -auth` 

to register a new user.  

## ACCOUNTS

Ayadn supports multiple accounts.

Register a new user with 

`ayadn -auth` 

at any moment.

You can then switch between accounts:

`ayadn switch @ericd` 

or 

`ayadn -@ ericd`  

## DATA

All Ayadn files and folders are created in your 'home' folder. 

On Mac OS X, it looks like this:

```
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
```

Each authorized account has its set of folders and databases.

This is also the repository of the configuration file: 

`config.yml`

Although there's the `set` command in Ayadn to configure most parameters, you can of course edit the file manually.

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

`ayadn blacklist help import`

`ayadn alias help create`  


## SHORTCUTS

Most examples will include the 'complete' command followed by the 'shortcut' command. 

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

`ayadn -se movies hollywood`

`ayadn -FO @ericd` 
