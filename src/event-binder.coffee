{Browser} = require './browser'
{PackageManager} = require './package-manager'
{Storage} = require './storage'
{Runtime} = require './runtime'

class EventBinder

  constructor: ->
    @port = null

  init: ->
    {Browser} = require './browser'
    {PackageManager} = require './package-manager'
    {Storage} = require './storage'
    {Runtime} = require './runtime'
    # @port = {}
    # @addEventListener()
    # TODO: Implement me
    require("sdk/page-mod").PageMod({
        include: /.*proxmate\.me.*/,
        contentScriptFile: [
            require('sdk/self').data.url("bower_components/jquery/dist/jquery.js"),
            require('sdk/self').data.url("src/page-worker/proxmate.js")
        ],
        onAttach: (worker) =>
          @handlePort(worker.port)
    });

    # createPagemod(/.*youtube\.com\/results.*/, 'modules/youtube-search.js');

  handlePort: (port) ->
    port.on('installPackage', (payload) ->
      PackageManager.installPackage(payload.packageId, (response) ->
        port.emit(payload.eventId, response)
      )
    )

    port.on('getProxmateGlobalStatus', (payload) ->
      {Storage} = require './storage'
      console.info '---> in proxmate global status'
      console.info this
      console.info Storage
      status = Storage.get('global_status')
      if status
        port.emit(payload.eventId, status)
      else
        port.emit(payload.eventId, false)
    )

    port.on('setProxmateGlobalStatus', (payload) ->
      newStatus = payload.newStatus
      if typeof newStatus != 'boolean'
        newStatus = false

      Storage.set('global_status', newStatus)

      # Start / Stop ProxMate service if neccesary
      if newStatus
        Runtime.start()
      else
        Runtime.stop()

      port.emit(payload.eventId, true)
    )

    port.on('getInstalledPackages', (payload) ->
      packages = PackageManager.getInstalledPackages()
      port.emit(payload.eventId, packages)
    )

    port.on('removePackage', (payload) ->
      packageId = payload.packageId
      PackageManager.removePackage(packageId)

      port.emit(payload.eventId, true)
    )

    port.on('getDonationkey', (payload) ->
      key = Storage.get('donation_key')

      port.emit(payload.eventId, key)
    )

    port.on('setDonationkey', (payload) ->
      key = payload.donationKey
      if key?
        Storage.set('donation_key', key)
      else
        Storage.remove('donation_key')

      {Runtime} = require('./runtime')
      Runtime.restart()

      port.emit(payload.eventId, true)
    )

    port.on('getUrlFor', (payload) ->
      port.emit(payload.eventId, require('sdk/self').data.url(payload.url))
    )

    port.on('openUrl', (payload) =>
      require("sdk/tabs").on("ready", (tab) =>
        worker = tab.attach({
          contentScriptFile: [
            require('sdk/self').data.url('bower_components/angular/angular.js'),
            require('sdk/self').data.url('bower_components/angular-route/angular-route.js'),
            require('sdk/self').data.url('src/pages/install.js'),
            require('sdk/self').data.url('src/pages/services/chrome.js')
          ]
        })
        @handlePort worker.port
      );

      require("sdk/tabs").open(payload.url)
    )

exports.EventBinder = new EventBinder()
