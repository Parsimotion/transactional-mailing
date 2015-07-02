requiredProcessEnv = (name) ->
  throw new Error("You must set the " + name + " environment variable")  unless process.env[name]
  process.env[name]
"use strict"
path = require("path")
_ = require("lodash")

# All configurations will extend these options
# ============================================
all =
  env: process.env.NODE_ENV

  # Root path of server
  root: path.normalize(__dirname + "/../../..")

  # Server port
  port: process.env.PORT or 9000

  # Should we populate the DB with sample data?
  seedDB: false

  # Secret for session, you will want to change this and make it an environment variable
  secrets:
    session: process.env.SESSION_SECRET or "transactional-mailing-secret"

  # MongoDB connection options
  mongo:
    options:
      db:
        safe: true

  producteca:
    uri: process.env.PRODUCTECA_API or "http://api.producteca.com"
    clientID: process.env.PRODUCTECA_CLIENTID or "id"
    clientSecret: process.env.PRODUCTECA_CLIENTSECRET or "secret"
    callbackURL: (process.env.DOMAIN or "") + "/auth/producteca/callback"

authServerUrl = process.env.AUTHORIZATION_SERVER_URL
if authServerUrl?
  _.assign all.producteca,
    authorizationURL: "#{authServerUrl}/oauth/authorise"
    tokenURL: "#{authServerUrl}/oauth/token"
    profileUrl: "#{authServerUrl}/users/me"

# Export the config object based on the NODE_ENV
# ==============================================
module.exports = _.merge(all, require("./" + process.env.NODE_ENV + ".coffee") or {})
