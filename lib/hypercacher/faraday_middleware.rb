require 'faraday'

class Hypercacher
  class FaradayMiddleware < Faraday::Middleware
    Faraday.register_middleware :request, :hypercacher => self

    def initialize(app, cache)
      super(app)
      @cache = cache
    end

    def call(env)
      request = Hypercacher::Request.from_env(env)
      cached_response = @cache.fetch(request)

      if cached_response.nil? || cached_response.stale?
        @cache.set_conditional_headers!(request)
        resp = @app.call(request.to_env)
        @cache.store(request, resp)
        resp
      else
        cached_response
      end
    end

  end

end

