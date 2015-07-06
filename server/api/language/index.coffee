"use strict"
express = require("express")
auth = require("../../auth/auth.service")
router = express.Router()

router.get "/", auth.authenticated, (req, res) ->
  res.sendfile 'server/locales/es.json'

module.exports = router
