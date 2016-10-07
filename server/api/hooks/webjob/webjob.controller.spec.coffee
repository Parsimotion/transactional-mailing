require('chai').use require('sinon-chai')
should = require("chai").should()
app = require("../../../app")
User = require("../../user/user.model")
SalesOrder = require("../../salesorder/salesorder.model")
sinon = require("sinon")
Promise = require("bluebird").Promise
proxyquire = require("proxyquire")
_ = require("lodash")
config = require("../../../config/environment")

req = null
res = null
user = null
webjobController = null
mandrillMock = null
messagesMock = null
productecaApiMock = null

describe "WebjobController", ->

  beforeEach (done) ->
    messagesMock = send: (message, cb) -> cb status: "sent"
    mandrillMock = Mandrill: -> messages: messagesMock
    productecaApiMock =
      getSalesOrder: ->
        new Promise (resolve) ->
          resolve
            contact:
              name: "Jose Hernandez"
              contactPerson: "Juan Jose Hernandez"
              mail: 'jose.hernandez@gmail.com'
            lines: [
              product:
                id: 97
                description: "Excelente Producto"
            ]
      getProduct: ->
        new Promise (resolve) ->
          resolve
            id: 97
            description: "Excelente Producto"
            sku: "123456789"
            notes: "Notas exclusivas para vos"

    productecaSdkMock = Api: -> productecaApiMock


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
        enabled: true
        content:
          from:
            name: "Juan Perez"
            email: "juan@gmail.com"
          subject: "Gracias por tu compra {{contact.name}}"
          body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}. {{product.notes}}</h1>{{/each}}</body>"
      ]
    )
    res = send: sinon.spy()
    user.save ->
      req = user:
        _id: user.id
      done()

  afterEach (done) ->
    user.remove ->
      SalesOrder.remove().exec().then ->
        done()

  it "should send 403 - Invalid Signature when the POST does not include the correct signature header", (done) ->
      req =
        headers:
          signature: "wrong signature"
      webjobController.notification req, res
      res.send.lastCall.args[0].should.eql 403
      res.send.lastCall.args[1].should.eql "Invalid signature"
      done()

  it "should get product details", (done) ->
      req =
        headers:
          signature: config.webjob.signature
        body:
          companyId: 410
          salesOrderId: 125

      sinon.spy productecaApiMock, 'getProduct'
      webjobController.notification(req, res).then ->
        productecaApiMock.getProduct.should.have.been.calledWith 97
        done()

  it "should send the compiled message when notification is called and the template is enabled", (done) ->
      req =
        headers:
          signature: config.webjob.signature
        body:
          companyId: 410
          salesOrderId: 125

      expected =
        message:
          html: "<body><h1>Gracias por comprar un Excelente Producto. Notas exclusivas para vos</h1></body>"
          subject: "Gracias por tu compra Jose Hernandez"
          from_email: "juan@gmail.com"
          from_name: "Juan Perez"
          to: [
            email: 'jose.hernandez@gmail.com'
            name: "Juan Jose Hernandez"
            type: "to"
          ]
          bcc_address: undefined

      sinon.spy messagesMock, 'send'
      webjobController.notification(req, res).then ->
        messagesMock.send.should.have.been.calledWith expected
        done()

  it "should send message as plain text if type is text", (done) ->
    template = user.templates[0]
    template.content.type = "text"

    user.save ->
      req =
        headers:
          signature: config.webjob.signature
        body:
          companyId: 410
          salesOrderId: 125

      expected =
        message:
          text: "<body><h1>Gracias por comprar un Excelente Producto. Notas exclusivas para vos</h1></body>"
          subject: "Gracias por tu compra Jose Hernandez"
          from_email: "juan@gmail.com"
          from_name: "Juan Perez"
          to: [
            email: 'jose.hernandez@gmail.com'
            name: "Juan Jose Hernandez"
            type: "to"
          ]
          bcc_address: undefined

      sinon.spy messagesMock, 'send'
      webjobController.notification(req, res).then ->
        messagesMock.send.should.have.been.calledWith expected
        done()

  it "should not send any message and return 200 OK when the tempate is disabled", (done) ->
      req =
        headers:
          signature: config.webjob.signature
        body:
          companyId: 410
          salesOrderId: 125

      user.templates[0].enabled = false
      user.save ->
        sinon.spy messagesMock, 'send'
        webjobController.notification(req, res).then ->
          messagesMock.send.should.not.have.been.called
          done()

  it "should send 409 when an order was already processed", (done) ->
      req =
        headers:
          signature: config.webjob.signature
        body:
          companyId: 410
          salesOrderId: 125

      new SalesOrder(_id: 125).save ->
        webjobController.notification(req, res).then ->
          res.send.lastCall.args[0].should.eql 409
          done()
