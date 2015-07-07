"use strict"

mongoose = require("mongoose")
Promise = require("bluebird")
Promise.promisifyAll mongoose
_ = require("lodash")

Schema = mongoose.Schema

authTypes = ["producteca"]

UserSchema = new Schema
  name: String
  email:
    type: String
    lowercase: true
    required: true
    unique: true

  provider: String
  providerId: Number

  companyId:
    type: Number
    unique: true

  tokens:
    producteca: String

  templates: [
    name:
      type: String
      required: true
    content:
      from:
        name:
          type: String
          required: true
        email:
          type: String
          required: true
      subject:
        type: String
        required: true
      body:
        type: String
        required: true
  ]

UserSchema.methods.getTemplate = (id) ->
  template = _.find @templates, (it) -> it._id.toString() is id
  throw new Error "entity_not_found" if not template
  template

module.exports = mongoose.model("User", UserSchema)
