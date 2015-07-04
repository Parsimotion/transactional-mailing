###*
Main application routes
###
"use strict"
errors = require("./components/errors")
auth = require("./auth/auth.service")
module.exports = (app) ->
  home = (req, res) ->
    if req.isAuthenticated()
      res.sendfile app.get("appPath") + "/main.html"
    else
      res.sendfile app.get("appPath") + "/landing.html"

  # Insert routes below
  app.get "/", home
  app.use "/api/users", require("./api/user")
  app.use "/api/hooks/webjob", require("./api/hooks/webjob")
  app.use "/api/templates", require("./api/templates")
  app.use "/auth", require("./auth")
  app.get "/logout", auth.logout

  # All undefined asset or api routes should return a 404
  app.route("/:url(api|auth|components|app|bower_components|assets)/*").get errors[404]

  # All other routes should redirect to the home
  app.route("/*").get home
