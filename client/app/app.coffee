'use strict'

window.app = angular.module 'transactional-mailing-app', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.router',
  'ui.bootstrap',
  'pascalprecht.translate',
  'ui.bootstrap'
]
.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  $urlRouterProvider
  .otherwise '/'

  $locationProvider.html5Mode true

.config ($translateProvider) ->
  $translateProvider.useUrlLoader 'api/language'
  $translateProvider.determinePreferredLanguage()
  $translateProvider.useSanitizeValueStrategy 'sanitize'
