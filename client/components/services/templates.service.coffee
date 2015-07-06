app.factory 'Template', (Resource) ->
  baseUrl = '/api/templates'
  Template = Resource baseUrl + '/:id',
    id: '@_id'
  ,
    update:
      method: 'PUT'
    test:
      method: 'POST'
      url: baseUrl + '/test'
