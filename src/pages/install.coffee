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
  .controller 'InstallCtrl', ['$scope', 'Chrome', '$routeParams', ($scope, Chrome, $routeParams) ->
    $scope.status = 'Installing...'

    Chrome.installPackage(window.location.search.split('packageId=')[1], (response) ->
      if response.success
        $scope.status = 'Installed successfully!'
        $scope.$digest()
      else
        $scope.status = response.message
        $scope.$digest()
    )
  ]
