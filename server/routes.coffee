###*
Main application routes
###
"use strict"
errors = require("./components/errors")
auth = require("./auth/auth.service")

module.exports = (app) ->
  # Insert routes below
  app.get "/", auth.renderLandingIfNotAuthenticated, (req, res) -> res.sendfile "server/index.html"
  app.use "/api/users", require("./api/user")
  app.use "/api/hooks/webjob", require("./api/hooks/webjob")
  app.use "/api/settings", require("./api/settings")
  app.use "/auth", require("./auth")
  app.get "/logout", auth.logout

  # All undefined asset or api routes should return a 404
  app.route("/:url(api|auth|components|app|bower_components|assets)/*").get errors[404]
