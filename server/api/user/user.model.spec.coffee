should = require("chai").should()
app = require("../../app")
User = require("./user.model")

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

describe "User Model", ->
  templateId = null
  before (done) ->
    User.remove().exec().then ->
      templateId = user.templates[0].id
      done()

  afterEach (done) ->
    User.remove().exec().then ->
      done()
  it "should store the provider and its id", (done) ->
    new User(
      email: 'juan@gmail.com'
      provider: 'producteca'
      providerId: 12345678
    ).save ->
      User.find {}, (err, users) ->
        users[0].should.have.property "provider", "producteca"
        users[0].should.have.property "providerId", 12345678
        done()

  it "should begin with no users", (done) ->
    User.find {}, (err, users) ->
      users.should.have.length 0
      done()

  it "should fail when saving a duplicate user", (done) ->
    user.save ->
      userDup = new User(user)
      userDup.save (err) ->
        should.exist err
        done()

  it "should fail when saving without an email", (done) ->
    user.email = ""
    user.save (err) ->
      should.exist err
      done()


  describe "when getTemplate is called", (done) ->
    it "should return the template when it exists", (done) ->
      template = user.getTemplate templateId
      template.name.should.equal 'template1'
      done()

    it "should return return undefined when it does not exist", (done) ->
      getTemplate = -> user.getTemplate 'wrong_id'
      getTemplate.should.throw "entity_not_found"
      done()
