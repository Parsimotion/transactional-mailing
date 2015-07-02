"use strict"
passport = require("passport")
config = require("../config/environment")

exports.authenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.send 401

exports.redirectIfNotAuthenticated = (req, res, next) ->
  return next() if req.isAuthenticated()
  res.redirect "/auth/producteca"
