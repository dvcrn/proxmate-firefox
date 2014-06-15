{EventBinder} = require './event-binder'

class Browser
  constructor: ->
    @statusButton = null
    @panel = null

  init: ->
    {EventBinder} = require './event-binder'

  generateButtons: ->
    require('sdk/ui')
    panels = require("sdk/panel")
    { ToggleButton } = require('sdk/ui/button/toggle')
    self = require("sdk/self")

    if @statusButton?
      @statusButton.destroy()
    if @panel?
      @panel.destroy()

    @statusButton = ToggleButton({
      id: "my-button",
      label: "my button",
      icon: {
        "16": require('sdk/self').data.url("ressources/images/icon16.png"),
        "24": require('sdk/self').data.url("ressources/images/icon24.png"),
        "48": require('sdk/self').data.url("ressources/images/icon48.png")
      },
      onChange: (state) =>
        if state.checked
          @panel.show {
            position: @statusButton
          }
    })

    @panel = panels.Panel({
      contentURL: require('sdk/self').data.url("pages/popup/index.html"),
      width: 264 # 250px base + 14px padding
      onHide: =>
        @statusButton.state('window', {checked: false})
    })

    EventBinder.handlePort(@panel.port)


  ###*
   * Sets browser wide proxy to autoconfig
   * @param {String}   pacScript the autoconfig string
   * @param {Function} callback  callback to execute after
  ###
  setProxyAutoconfig: (pacScript, callback) ->
    if not callback?
      callback = ->

    pac = "data:text/javascript,#{pacScript}"

    require("sdk/preferences/service").set("network.proxy.type", 2)
    require("sdk/preferences/service").set("network.proxy.autoconfig_url", pac)
    callback()


  ###*
   * Removes all custom proxies and resets to system
   * @param  {Function} callback callback
  ###
  clearProxy: (callback) ->
    if not callback?
      callback = ->

    require("sdk/preferences/service").reset("network.proxy.type")
    require("sdk/preferences/service").reset("network.proxy.http")
    require("sdk/preferences/service").reset("network.proxy.http_port")
    callback()

  ###*
   * Sets the browser icon
   * @param {string} iconUrl the url for the icon
  ###
  setIcon: (iconUrl) ->
    @statusButton.icon = {
      "16": require('sdk/self').data.url(iconUrl),
      "24": require('sdk/self').data.url(iconUrl),
      "48": require('sdk/self').data.url(iconUrl)
    }

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
    delete require("sdk/simple-storage").storage[key]

  ###*
   * Writes a object into browser storage
   * @param  {Object} object the object (key, value) to write
  ###
  writeIntoStorage: (object) ->
    ss = require("sdk/simple-storage").storage
    for key of object
      console.info "~~~~~~~> Writing into firefox storage: #{key} => #{object[key]}"
      ss[key] = object[key]

  ###*
   * Returns a element from storage
   * @param  {string}   key      the elements key
   * @param  {Function} callback callback
  ###
  retrieveFromStorage: (key, callback) ->
    if key == null
      console.info "~~~~~~~> Returning all keys"
      console.info require("sdk/simple-storage").storage
      callback require("sdk/simple-storage").storage
    else
      callback require("sdk/simple-storage").storage[key]

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
          successCallback JSON.parse(response.text)
        else
          # Map object so it looks similar to the normal XHR object
          response.responseJSON = JSON.parse(response.text)
          errorCallback response
    }).get()

  ###*
   * wrapper for setTimeout function
   * @param {Function} callback [description]
   * @param {int}   ms       number
  ###
  setTimeout: (callback, ms) ->
    return require('sdk/timers').setTimeout(callback, ms)

  ###*
   * Wrapper for clearInterval function
   * @param  {Object} timeoutId timeout
  ###
  clearTimeout: (timeoutId) ->
    return require('sdk/timers').clearTimeout(timeoutId)


exports.Browser = new Browser()
