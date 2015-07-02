passport = require("passport")
ProductecaStrategy = require("passport-producteca").Strategy

exports.setup = (User, config) ->
  passport.use new ProductecaStrategy
    clientID: config.producteca.clientID
    clientSecret: config.producteca.clientSecret
    callbackURL: config.producteca.callbackURL
    authorizationURL: config.producteca.authorizationURL
    tokenURL: config.producteca.tokenURL
    profileUrl: config.producteca.profileUrl
  , (accessToken, _, profile, done) ->
    User.findOne { provider: "producteca", providerId: profile.id }, (err, user) ->
      return done err if err

      setTokenAndSave = =>
        user.tokens.producteca = accessToken
        user.save()
        user

      return done null, setTokenAndSave() if user?

      user = new User
        name: "#{profile.profile.firstName} #{profile.profile.lastName}"
        email: profile.email
        role: "user"
        username: profile.credentials.username
        provider: "producteca"
        providerId: profile.id
        tokens:
          producteca: accessToken

      user.save (err) ->
        done err if err
        done null, user
