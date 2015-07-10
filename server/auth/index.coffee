"use strict"

express = require("express")
config = include("config/environment")
User = include("api/user/user.model")

# Passport Configuration
require("./passport.serializer")
require("./producteca/passport").setup User, config

router = express.Router()
router.use "/producteca", require("./producteca")

module.exports = router
