{PackageManager} = require './package-manager'
{ServerManager} = require './server-manager'
{ProxyManager} = require './proxy-manager'
{Storage} = require './storage'
{Browser} = require './browser'

class Runtime
  init: ->
    {PackageManager} = require './package-manager'
    {ServerManager} = require './server-manager'
    {ProxyManager} = require './proxy-manager'
    {Storage} = require './storage'
    {Browser} = require './browser'

  ###*
   * Starts the app. Retrieves servers and sets pac
  ###
  start: ->
    Browser.generateButtons()
    console.info '-----> starting runtime....'
    globalStatus = Storage.get('global_status')
    console.info "global status: #{globalStatus}"
    if not globalStatus
      console.info 'I am deactivated????'
      @stop()
      return

    Browser.setIcon("ressources/images/icon48.png")
    Browser.setIcontext("")

    console.info 'start after browser'
    packages = PackageManager.getInstalledPackages()
    console.info 'start after package manager'
    servers = ServerManager.getServers()
    console.info 'start after server manager'

    if packages.length == 0 or servers.length == 0
        if packages.length == 0
          console.info '---------> no packages or servers'
          Browser.setIcontext("None")
          console.info 'start after seticontext to none'
    else
        Browser.setIcontext("")
        console.info 'start before pac'
        pac = ProxyManager.generateProxyAutoconfigScript(packages, servers)
        console.info(pac)
        console.info 'start before proxy manager pac'
        ProxyManager.setProxyAutoconfig(pac)

  ###*
   * Restarts application flow. This means the app is already running and now getting started again.
  ###
  restart: ->
    console.info '-----> restarting runtime'
    @stop()
    ServerManager.init( =>
      PackageManager.init() # Since we want to fetch new packages / update the existing ones
      console.info '-----> before starting runtime again'
      @start()
    )

  ###*
   * Removed the proxy from chrome
  ###
  stop: ->
    Browser.setIcontext("Off")
    Browser.setIcon("ressources/images/icon48_grey.png")
    ProxyManager.clearProxy()

exports.Runtime = new Runtime()
