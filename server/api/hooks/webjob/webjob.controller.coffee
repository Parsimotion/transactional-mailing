User = require("../../user/user.model")
SalesOrder = require("../../salesorder/salesorder.model")
ProductecaApi = require("producteca-sdk").Api
Promise = require("bluebird")
Handlebars = require("handlebars")
mandrill = require("mandrill-api/mandrill")
config = require("../../../config/environment")

exports.notification = (req, res) ->
  if not isSignatureValid req
    return res.send 403, "Invalid signature"

  User.findOneAsync(companyId: req.body.companyId).then (user) =>
    template = user.templates[0]
    return res.send 200 if !template.enabled

    productecaApi = new ProductecaApi
      accessToken: user.tokens.producteca
      url: config.producteca.uri

    salesOrderId = req.body.salesOrderId
    productecaApi.getSalesOrder(salesOrderId).then (salesOrder) ->
      mandrillClient = new mandrill.Mandrill config.mandrill.apiKey
      return if user.templates.length is 0

      subjectTemplate = Handlebars.compile template.content.subject
      bodyTemplate = Handlebars.compile template.content.body

      message =
        html: bodyTemplate salesOrder
        subject: subjectTemplate salesOrder
        from_email: template.content.from.email
        from_name: template.content.from.name
        to: [
          email: salesOrder.contact.mail
          name: salesOrder.contact.contactPerson
          type: "to"
        ]

      SalesOrder.createAsync(_id: salesOrderId)
      .then ->
        mandrillClient.messages.send
          message: message
        , (result) ->
          res.send result
        , (err) -> res.send 400, err
      , (err) ->
        res.send 409, err

  .catch (e) =>
    console.log e
    res.send 400, e.message or e

isSignatureValid = (req) ->
  req.headers["signature"] is (process.env.WEBJOB_SIGNATURE or "default")
