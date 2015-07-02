"use strict"
passport = require("passport")

passport.serializeUser (tokens, done) ->
  encodedTokens = new Buffer(JSON.stringify(tokens)).toString("base64")
  done null, encodedTokens

passport.deserializeUser (encodedTokens, done) ->
  tokens = JSON.parse(new Buffer(encodedTokens, "base64").toString("utf8"))
  done null, tokens
