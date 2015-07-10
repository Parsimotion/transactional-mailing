"use strict"
express = require("express")
passport = require("passport")
auth = include("auth/auth.service")

router = express.Router()

router

.get "/", passport.authenticate("producteca")

.get "/callback", passport.authenticate("producteca",
  successRedirect: "/",
  failureRedirect: "/"
)

module.exports = router
