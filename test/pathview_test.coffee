chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'pathview', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/pathview')(@robot)

  it 'registers a pathview listener', ->
    expect(@robot.respond).to.have.been.calledWith(/pathview me foo to bar/)

  it 'registers a hear listener', ->
    expect(@robot.respond).to.have.been.calledWith(/pvc me foo to bar/)
