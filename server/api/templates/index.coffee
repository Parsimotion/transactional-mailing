"use strict"
express = require("express")
controller = require("./templates.controller.coffee")
auth = require("../../auth/auth.service")

router = express.Router()

router.get "/", auth.authenticated, controller.query
router.get "/:id", auth.authenticated, controller.get
router.put "/:id", auth.authenticated, controller.update

module.exports = router
