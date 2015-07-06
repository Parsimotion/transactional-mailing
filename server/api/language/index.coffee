"use strict"
express = require("express")
auth = require("../../auth/auth.service")
path = require("path")

router = express.Router()

router.get "/", auth.authenticated, (req, res) ->
  serverPath = path.normalize __dirname + "/../.."
  res.sendfile path.join serverPath, "locales", "es.json"

module.exports = router
