beforeEach ->
  module("transactional-mailing-app")

  inject ($httpBackend) -> $httpBackend.whenGET((url) -> /api\/language\?lang=/.test url).respond()
