"use strict"

mongoose = require("mongoose")
Promise = require("bluebird")
Promise.promisifyAll mongoose

Schema = mongoose.Schema

SalesOrderSchema = new Schema
  _id:
    type: Number
    unique: true
    required: true

module.exports = mongoose.model("SalesOrder", SalesOrderSchema)
