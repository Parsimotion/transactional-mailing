"use strict"
express = require("express")
controller = require("./user.controller")
config = require("../../config/environment")
auth = require("../../auth/auth.service")

router = express.Router()

router.get "/me", auth.authenticated, controller.me

module.exports = router
