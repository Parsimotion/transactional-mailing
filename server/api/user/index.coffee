"use strict"
express = require("express")
controller = require("./user.controller")
config = include("config/environment")
auth = include("auth/auth.service")

router = express.Router()

router.get "/me", auth.authenticated, controller.me

module.exports = router
