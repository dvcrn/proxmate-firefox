checkUrl = ->
  url = location.href
  if url.indexOf('package/') == -1
    return

  # Execute code here. Check the proxmate button, change it's class and put event listeners on it :)
  installButton = $('.installbutton')

  if installButton.hasClass('pxm-installbutton')
    currentUrl = url
    return

  # Indicate that the user can install now
  installButton.text('Add to ProxMate')

  # add a custom class so we can style on the server side
  installButton.addClass('pxm-installbutton')

  # Remove the link, if any. This script will handle the onClick now
  installButton.attr('a', '')

  # Finally, add a click handler
  $('.confirmInstallButton').mouseup ->
    # Packageid is set by the server as a seperate attribute
    packageid = installButton.attr('packageid')

    eventId = "event-#{new Date().getTime()}"
    self.port.on(eventId, (url) =>
      fullUrl = "#{url}?packageId=#{packageid}"
      self.port.emit('openUrl', {url: fullUrl})
    )

    self.port.emit('getUrlFor', { url: 'pages/install/index.html', eventId: eventId } )

  $('.cancelbutton').mouseup ->
    $('.installPopupWrapper').fadeOut('fast')

  # Finally, add a click handler
  installButton.mouseup ->
    $('.installPopupWrapper').fadeIn('fast')

setInterval checkUrl, 1000
