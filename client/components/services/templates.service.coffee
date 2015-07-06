app.factory "Template", (Resource) ->
  Template = Resource "/api/templates/:id",
    id: '@_id'
  ,
    update:
      method: 'PUT'
