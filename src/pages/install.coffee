'use strict'

angular.module('proxmateApp', [
  'ngRoute',
  'chrome'
])
  .config ($locationProvider, $routeProvider) ->
    $locationProvider.hashPrefix('!')

    $routeProvider
      .when '/',
        templateUrl: 'views/install.html'
        controller: 'InstallCtrl'
      .when '/install/:packageId',
        templateUrl: 'views/install.html'
        controller: 'InstallCtrl'
      .otherwise redirectTo: '/'

angular.module('proxmateApp')
  .controller 'MainCtrl', ['$scope', '$location', '$route', '$routeParams', ($scope, $location) ->
    console.info window.location.search.split('packageId=')[1]
  ]

angular.module('proxmateApp')
  .controller 'InstallCtrl', ['$rootScope', 'Chrome', '$routeParams', '$http', ($rootScope, Chrome, $routeParams, $http) ->
    $rootScope.method = 'confirm'
    $rootScope.method = window.location.search.split('method=')[1].split('&')[0]

    packageId = window.location.search.split('packageId=')[1].split('&')[0]
    console.info "method:"
    console.info window.location.search.split('method=')[1].split('&')[0]

    Chrome.xhr("https://api.proxmate.me/package/#{packageId}.json", (data) =>
      $rootScope.packageData = data
      $rootScope.$digest()
    )

    $rootScope.close = ->
      window.close()

    $rootScope.install = ->
      $rootScope.method = 'install'
      $rootScope.status = 'Installing...'
      Chrome.installPackage(packageId, (response) ->
        if response.success
          $rootScope.status = 'Installed successfully!'
          $rootScope.$digest()
        else
          $rootScope.status = response.message
          $rootScope.$digest()
      )
  ]
