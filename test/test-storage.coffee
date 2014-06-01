{Storage} = require("../lib/storage")

describe 'Storage Module', ->
  it 'should set / get values correctly', ->
    testValue = 123
    Storage.set('test', testValue)
    assert.equal(Storage.get('test'), testValue)

    testArray = [123, 456]
    Storage.set('test', testArray)
    assert.equal(Storage.get('test'), testArray)

    testObj = {test: 'foobar'}
    Storage.set('test', testObj)
    assert.equal(Storage.get('test'), testObj)

  it 'should flush storage content correctly', ->
    Storage.set('123', 56789)
    assert.equal(Storage.get('123'), 56789)
    Storage.flush()
    assert.equal(Storage.get('123'), null)
