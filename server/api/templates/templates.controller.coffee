User = require("../user/user.model")
_ = require("lodash")
Promise = require("bluebird").Promise
Handlebars = require("handlebars")

class TemplatesController

  query: (req, res) =>
    @_send res, @_getUser(req).then (user) -> user.templates

  get: (req, res) =>
    @_send res, @_getTemplate(req, res).then ({template}) -> template

  update: (req, res) =>
    @_send res, @_getTemplate(req, res).then ({user, template}) =>
      _.assign template, _.omit req.body, '_id'
      @_save(user).then -> template

  create: (req, res) =>
    @_send res, @_getUser(req).then (user) =>
      user.templates.push req.body
      @_save(user).then (user) ->
        _.last user.templates

  remove: (req, res) =>
    @_send res, @_getUser(req).then (user) =>
      user.templates.pull _id: req.param 'id'
      @_save(user).then -> 200

  test: (req, res) =>
    @_send res, @_getTemplate(req, res).then ({template}) ->
      subjectTemplate = Handlebars.compile template.content.subject
      bodyTemplate = Handlebars.compile template.content.body

      from: template.content.from
      subject: subjectTemplate req.body
      body: bodyTemplate req.body

  _getUser: (req) ->
    User.findByIdAsync req.user._id

  _getTemplate: (req, res) =>
    @_getUser(req).then (user) ->
      template = user.getTemplate req.param 'id'
      user: user
      template: template

  _save: (user) ->
    new Promise (resolve, reject) ->
      user.save (err) ->
        return reject err if err
        resolve user

  _send: (res, query) =>
    query
    .then (msj) =>
      res.send msj
    .catch (err) =>
      @_sendError res, err

  _sendError: (res, err) =>
    return res.send 404 if err.message is "entity_not_found"
    res.send 400, err


module.exports = new TemplatesController
