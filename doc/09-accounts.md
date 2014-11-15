# AUTHORIZE

Authorize Ayadn for a specific user account.

`ayadn authorize`

or 

`ayadn -auth`

Ayadn will give you a link leading to the official App.net registration page.

After your successful login, you will be redirected to the Ayadn authorization page.

Copy the code (token) you will find there and paste it into Ayadn: a new user will be created and automatically logged in.  

*Note: authorizing an already authorized user updates the old content with the new content: token, name, etc.*

# SWITCH

Switch between your authorized accounts.

`ayadn switch @ericd`

`ayadn switch ericd`

Alternative syntax:

`ayadn -@ ericd`

List your authorized accounts:

`ayadn switch -l`

`ayadn -@ -l`

# UNAUTHORIZE

Unauthorize an Ayadn user account.

`ayadn unauthorize @ericd`

`ayadn -UA ericd`

You can specify the `--delete` (`-D`) option to force delete the account folders:

`ayadn -UA -D @ericd`
