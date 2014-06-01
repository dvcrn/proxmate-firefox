class Storage
  # Keep storage in object for faster lookup
  internStorage: {}

  init: ->

  ###*
   * Deletes all content from RAM storage
  ###
  flush: ->
    @internStorage = {}

  ###*
   * Returns value for 'key' from Storage
   * @return {String|Array} the value inside the storage
  ###
  get: (key) ->
    return @internStorage[key]

  ###*
   * Sets 'value' for 'key' in storage
  ###
  set: (key, value) ->
    @internStorage[key] = value
    # copyIntoChromeStorage()

exports.Storage = new Storage()
