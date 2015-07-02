"use strict"

express = require("express")
config = require("../config/environment")
User = require("../api/user/user.model")

# Passport Configuration
require("./passport.serializer")
require("./producteca/passport").setup User, config

router = express.Router()
router.use "/producteca", require("./producteca")

module.exports = router
