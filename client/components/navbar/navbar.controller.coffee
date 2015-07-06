'use strict'

angular.module 'transactional-mailing-app'
.controller 'NavbarCtrl', ($scope, $location, Auth) ->
  $scope.getCurrentUser = Auth.getCurrentUser

  $scope.logout = ->
    window.location = "/logout"
