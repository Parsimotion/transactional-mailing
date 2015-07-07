should = require("chai").should()
app = require("../../app")
User = require("../user/user.model")
templatesController = require("./templates.controller")
sinon = require("sinon")

templateId = null
req = null
res = null
user = null

describe "TemplatesController", ->

  beforeEach (done) ->
    user = new User(
      provider: "producteca"
      name: "Fake User"
      email: "test@test.com"
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

  it "should return the user's templates when query is called", (done) ->
    templatesController.query(req, res).then ->
      templates = res.send.lastCall.args[0]
      templates[0].name.should.eql "template1"
      done()

  describe "when get is called", ->
    it "should return 200 OK with the proper template if it exists", (done) ->
      req.param = sinon.stub().returns templateId
      templatesController.get(req, res).then ->
        template = res.send.lastCall.args[0]
        template.name.should.eql "template1"
        done()

    it "should return 404 if the template does not exist", (done) ->
      req.param = sinon.stub().returns "wrong_id"
      templatesController.get(req, res).then ->
        res.send.lastCall.args[0].should.eql 404
        done()

  describe "when update is called", ->
    describe "and the template exists", ->
      beforeEach ->
        req.param = sinon.stub().returns templateId

      it "should return 200 OK with the proper template if it exists", (done) ->
        req.body =
          name: "template1"
          content:
            from:
              name: "Juan Perez"
              email: "nuevomail@gmail.com"
            subject: "Gracias por tu compra {{contact.name}}"
            body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}</h1>{{/each}}</body>"

        templatesController.update(req, res).then ->
          User.findOneAsync({}).then (user) ->
            user.templates[0].content.from.email.should.eql "nuevomail@gmail.com"
            done()

      it "should never update template id", (done) ->
        req.body =
          _id: "nuevo_id"
          name: "template1"
          content:
            from:
              name: "Juan Perez"
              email: "nuevomail@gmail.com"
            subject: "Gracias por tu compra {{contact.name}}"
            body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}</h1>{{/each}}</body>"

        templatesController.update(req, res).then ->
          User.findOneAsync({}).then (user) ->
            user.templates[0].id.should.eql templateId
            done()

    it "should return 404 if the template does not exist", (done) ->
      req.param = sinon.stub().returns "wrong_id"
      templatesController.update(req, res).then ->
        res.send.lastCall.args[0].should.eql 404
        done()

  it "should append the template when create is called", (done) ->
    req.body =
      name: "newTemplate"
      content:
        from:
          name: "Juan Perez"
          email: "otromail@gmail.com"
        subject: "Como te fue con tu compra?"
        body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}</h1>{{/each}}</body>"

    templatesController.create(req, res).then ->
      User.findOneAsync({}).then (user) ->
        user.templates[1].name.should.eql "newTemplate"
        done()

  it "should remove the template when remove is called", (done) ->
    req.param = sinon.stub().returns templateId
    templatesController.remove(req, res).then ->
      User.findOneAsync({}).then (user) ->
        user.templates.length.should.eql 0
        done()

  it "should return a template compiled with the passed template and sample order when test is called", ->
    req.body =
      sample:
        contact:
          name: "Jose Hernandez"
        lines: [
          product:
            description: "Excelente Producto"
        ]
      template:
        content:
          from:
            name: "Juan Perez"
            email: "juan@gmail.com"
          subject: "Gracias por tu compra {{contact.name}}"
          body: "<body>{{#each lines}}<h1>Gracias por comprar un {{product.description}}</h1>{{/each}}</body>"

    templatesController.test req, res
    expected =
      from: "juan@gmail.com"
      subject: "Gracias por tu compra Jose Hernandez"
      body: "<body><h1>Gracias por comprar un Excelente Producto</h1></body>"

    res.send.lastCall.args[0].should.eql expected


