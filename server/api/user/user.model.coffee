"use strict"

mongoose = require("mongoose")
Promise = require("bluebird")
Promise.promisifyAll mongoose

Schema = mongoose.Schema

authTypes = ["producteca"]

UserSchema = new Schema
  name: String
  email:
    type: String
    lowercase: true

  role:
    type: String
    default: "user"

  provider: String
  providerId: Number

  tokens:
    producteca: String

  settings:
    saved: Boolean

# Non-sensitive info we'll be putting in the token
UserSchema.virtual("token").get ->
  _id: @_id
  role: @role

###*
Validations
###

# Validate empty email
UserSchema.path("email").validate ((email) ->
  return true  if authTypes.indexOf(@provider) isnt -1
  email.length
), "Email cannot be blank"

# Validate email is not taken
UserSchema.path("email").validate ((value, respond) ->
  self = this
  @constructor.findOne
    email: value
  , (err, user) ->
    throw err  if err
    if user
      return respond(true)  if self.id is user.id
      return respond(false)
    respond true
    return

  return
), "The specified email address is already in use."

module.exports = mongoose.model("User", UserSchema)
