should = require("chai").should()
app = require("../../app")
User = require("./user.model")
user = new User(
  provider: "producteca"
  name: "Fake User"
  email: "test@test.com"
)

describe "User Model", ->
  before (done) ->
    User.remove().exec().then ->
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
