should = require("chai").should()
app = require("../../../app")
User = require("../../user/user.model")
sinon = require("sinon")
Promise = require("bluebird").Promise
proxyquire = require("proxyquire")
_ = require("lodash")

templateId = null
req = null
res = null
user = null
webjobController = null
mandrillMock = null
messagesMock = null

describe "WebjobController", ->

  beforeEach (done) ->
    messagesMock = send: (message, cb) -> cb status: "sent"
    mandrillMock = Mandrill: -> messages: messagesMock
    productecaSdkMock = Api: -> getSalesOrder: ->
      new Promise (resolve) ->
        resolve
          contact:
            name: "Jose Hernandez"
            contactPerson: "Juan Jose Hernandez"
            mail: 'jose.hernandez@gmail.com'
          lines: [
            product:
              description: "Excelente Producto"
          ]

    webjobController = proxyquire './webjob.controller',
      'mandrill-api/mandrill': mandrillMock
      'producteca-sdk': productecaSdkMock

    user = new User(
      provider: "producteca"
      name: "Fake User"
      email: "test@test.com"
      companyId: 410
      tokens:
        producteca: "apitoken"
      templates: [
        name: "template1"
        content:
          from:
            name: "Juan Perez"
            email: "juan@gmail.com"
          subject: "Gracias por tu compra {{contact.name}}"
          body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}</h1>{{/each}}</body>"
      ]
    )
    res = send: sinon.spy()
    user.save ->
      templateId = user.templates[0].id
      req = user:
        _id: user.id
      done()

  afterEach (done) ->
    user.remove -> done()

  it "should send 403 - Invalid Signature when the POST does not include the correct signature header", (done) ->
      req =
        headers:
          signature: "wrong signature"
      webjobController.notification req, res
      res.send.lastCall.args[0].should.eql 403
      res.send.lastCall.args[1].should.eql "Invalid signature"
      done()

  it "should send the compiled message when notification is called", (done) ->
      req =
        headers:
          signature: process.env.WEBJOB_SIGNATURE
        body:
          companyId: 410
          salesOrderId: 125

      expected =
        message:
          html: "<body><h1>Gracias por comprar un Excelente Producto</h1></body>"
          subject: "Gracias por tu compra Jose Hernandez"
          from_email: "juan@gmail.com"
          from_name: "Juan Perez"
          to: [
            email: 'jose.hernandez@gmail.com'
            name: "Juan Jose Hernandez"
            type: "to"
          ]

      sinon.spy messagesMock, 'send'
      webjobController.notification(req, res).then ->
        messagesMock.send.lastCall.args[0].should.eql expected
        done()
