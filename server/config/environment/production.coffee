"use strict"

# Production specific configuration
# =================================
module.exports =

  # Server IP
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or `undefined`

  # Server port
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080

  # MongoDB connection options
  mongo:
    uri: process.env.MONGO_URI or "mongodb://localhost/transactional-mailing"
    options:
      server:
        socketOptions:
          keepAlive: 1
      replset:
        socketOptions:
          keepAlive: 1
