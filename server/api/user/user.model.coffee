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
    required: true
    unique: true

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

module.exports = mongoose.model("User", UserSchema)
