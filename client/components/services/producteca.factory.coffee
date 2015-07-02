app.factory "Producteca", ($resource) ->
  envResource = $resource "/api/settings/env", { }

  envResource.get().$promise.then (env) =>
    (token) ->
      setAuthorizationHeader = (data, headersGetter) -> headersGetter().Authorization = "Bearer #{token}"
      toNames = (data) -> _.map (JSON.parse data), "name"
      endpoint = env.apiUrl

      $resource endpoint, {},
        user:
          method: "GET"
          url: "#{endpoint}/users/me"
          transformRequest: setAuthorizationHeader
