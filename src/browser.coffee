class Browser
  statusButton = null

  init: ->
    @statusButton = require("sdk/widget").Widget({
      id: "open-proxmate-btn",
      label: "Click to Activate/Deactivate Proxmate",
      contentURL: require('sdk/self').data.url("ressources/images/icon16.png"),
      # onClick: setPluginStatus
    })

  ###*
   * Sets browser wide proxy to autoconfig
   * @param {String}   pacScript the autoconfig string
   * @param {Function} callback  callback to execute after
  ###
  setProxyAutoconfig: (pacScript, callback) ->
    pac = "data:text/javascript,#{pacScript}"

    require("sdk/preferences/service").set("network.proxy.type", 2)
    require("sdk/preferences/service").set("network.proxy.autoconfig_url", pac)
    callback()


  ###*
   * Removes all custom proxies and resets to system
   * @param  {Function} callback callback
  ###
  clearProxy: (callback) ->
    require("sdk/preferences/service").reset("network.proxy.type")
    require("sdk/preferences/service").reset("network.proxy.http")
    require("sdk/preferences/service").reset("network.proxy.http_port")
    callback()

  ###*
   * Sets the browser icon
   * @param {string} iconUrl the url for the icon
  ###
  setIcon: (iconUrl) ->
    @statusButton.contentURL = require('self').data.url(iconUrl)

  ###*
   * Sets the text for the icon (if possible)
   * @param {string} text the text to set
  ###
  setIcontext: (text) ->
    console.info 'I am not implemented yet'

  ###*
   * Removes a key from the browser storage
   * @param  {string} key the key to remove
  ###
  removeFromStorage: (key) ->
    delete require("sdk/simple-storage")[key]

  ###*
   * Writes a object into browser storage
   * @param  {Object} object the object (key, value) to write
  ###
  writeIntoStorage: (object) ->
    ss = require("sdk/simple-storage")
    for key of object
      ss[key] = object[key]

  ###*
   * Returns a element from storage
   * @param  {string}   key      the elements key
   * @param  {Function} callback callback
  ###
  retrieveFromStorage: (key, callback) ->
    callback require("sdk/simple-storage")[key]

  ###*
   * Add a event listener for the message event
   * @param  {function} listener listener function
  ###
  addEventListener: (listener) ->

  ###*
   * Performs a xmlhttprequest
   * @param  {string} url             the url to request
   * @param  {string} type            POST or GET
   * @param  {Function} successCallback callback
   * @param  {Function} errorCallback   callback
  ###
  xhr: (url, type, successCallback, errorCallback) ->
    require("sdk/request").Request({
      url: url,
      onComplete: (response) ->
        if response.status == 200
          successCallback response.text
        else
          # Map object so it looks similar to the normal XHR object
          response.responseJSON = {}
          response.responseJSON.message = response.text
          errorCallback response
    }).get()

exports.Browser = new Browser()
