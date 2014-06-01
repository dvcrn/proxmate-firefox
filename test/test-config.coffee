{Config} = require("../lib/config")

describe 'Config', ->
  it 'should return config content correctly', ->
    Config.init({'primary_server': 'muh'})
    assert.equal(Config.get('primary_server'), 'muh')
