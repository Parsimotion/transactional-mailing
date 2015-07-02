Transformer = require("./transformer")
config = require("../../config/environment")
User = require("../user/user.model")

exports.index = (req, res) ->
  res.send 200, Transformer.toDto req.user

exports.env = (req, res) ->
  res.send 200, { apiUrl: config.producteca.uri }

exports.update = (req, res) ->
  User.findOneAsync(req.user._id).then (user) ->
    Transformer.updateModel req.user, req.body
    user.save (err) ->
      if err then res.json 400, err else res.send 200
