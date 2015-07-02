"use strict"
express = require("express")
controller = require("./settings.controller.coffee")
auth = require("../../auth/auth.service")

router = express.Router()

router.get "/env", controller.env
router.get "/", auth.authenticated, controller.index
router.put "/", auth.authenticated, controller.update

module.exports = router
