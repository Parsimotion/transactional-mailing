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
          from: "juan@gmail.com"
          subject: "Gracias por tu compra"
          body: "<body />"
      ]
    )
    res = send: sinon.spy()
    user.save ->
      templateId = user.templates[0].id
      req = user:
        _id: user._id.toString()
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
            from: "nuevomail@gmail.com"
            subject: "Gracias por tu compra"
            body: "<body />"

        templatesController.update(req, res).then ->
          User.findOneAsync({}).then (user) ->
            user.templates[0].content.from.should.eql "nuevomail@gmail.com"
            done()

      it "should never update template id", (done) ->
        req.body =
          _id: "nuevo_id"
          name: "template1"
          content:
            from: "nuevomail@gmail.com"
            subject: "Gracias por tu compra"
            body: "<body />"

        templatesController.update(req, res).then ->
          User.findOneAsync({}).then (user) ->
            user.templates[0]._id.toString().should.eql templateId.toString()
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
        from: "otromail@gmail.com"
        subject: "Como te fue con tu compra?"
        body: "<body />"

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
