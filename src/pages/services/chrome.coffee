'use strict'

angular.module('chrome', [])
  .factory 'Chrome', () ->

    emitMessage = (messageId, parameter, callback) ->

      portVar = {}
      if addon?
        console.info "addon.port exists"
        portVar.port = addon.port

      if self.port?
        console.info 'self.port is defined'
        portVar.port = self.port

      console.info "Triggering event: #{messageId}"
      # Generate a unique eventId for reading the response
      eventId = "event-#{new Date().getTime()}" + Math.random().toString(36).substring(7)
      portVar.port.on(eventId, callback)

      # Add eventId to parameter
      parameter.eventId = eventId
      portVar.port.emit(messageId, parameter)

    # Public API here
    {
      installPackage: (packageId, callback) ->
        emitMessage('installPackage', {packageId: packageId}, callback)

      getProxmateStatus: (callback) ->
        emitMessage('getProxmateGlobalStatus', {}, callback)

      setProxmateStatus: (status, callback) ->
        emitMessage('setProxmateGlobalStatus', {newStatus: status}, callback)

      getInstalledPackages: (callback) ->
        emitMessage('getInstalledPackages', {}, callback)

      removePackage: (packageId, callback) ->
        emitMessage('removePackage', {packageId: packageId}, callback)

      getDonationkey: (callback) ->
        emitMessage('getDonationkey', {}, callback)

      setDonationkey: (key, callback) ->
        emitMessage('setDonationkey', {donationKey: key}, callback)

      getUrlFor: (ressource, callback) ->
        emitMessage('getUrlFor', {url: ressource}, callback)

      openUrl: (url, callback) ->
        emitMessage('openUrl', {url: url}, callback)

      xhr: (url, callback) ->
        emitMessage('xhr', {url: url}, callback)
    }
