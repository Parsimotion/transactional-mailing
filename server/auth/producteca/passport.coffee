passport = require("passport")
ProductecaStrategy = require("passport-producteca").Strategy
_ = require("lodash")

exports.setup = (User, config) ->
  passport.use new ProductecaStrategy
    clientID: config.producteca.clientID
    clientSecret: config.producteca.clientSecret
    callbackURL: config.producteca.callbackURL
    authorizationURL: config.producteca.authorizationURL
    tokenURL: config.producteca.tokenURL
    profileUrl: config.producteca.profileUrl
  , (accessToken, __, profile, done) ->
    User.findOne { provider: "producteca", providerId: profile.id }, (err, user) ->
      return done err if err

      return done null, _.pick(user, '_id') if user?

      user = new User
        name: "#{profile.profile.firstName} #{profile.profile.lastName}"
        email: profile.email
        username: profile.credentials.username
        provider: "producteca"
        providerId: profile.id
        companyId: profile.company.id
        tokens:
          producteca: accessToken

      user.save (err) ->
        done err if err
        done null, user
