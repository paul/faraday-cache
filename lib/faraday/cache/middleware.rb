require 'faraday'

class Faraday::Cache
  class Middleware < Faraday::Middleware
    Faraday.register_middleware :request, :cache => self

    def initialize(app, cache_options = {})
      super(app)
      @cache = Faraday::Cache.new cache_options
    end

    def call(env)
      request = Faraday::Cache::Request.from_env(env)
      cached_response = @cache.fetch(request)

      # If there was nothing cached for this, make the request and store it
      if cached_response.nil?
        response = @app.call(request.to_env)
        @cache.store(request, response)

      # if there was a cached response, but it needs revalidation, make the request
      # and update the cache
      elsif cached_response.stale? || cached_response.needs_revalidation?
        @cache.set_conditional_headers!(request, cached_response)
        response = @app.call(request.to_env)
        cached_response.revalidate!(response)
        @cache.store(request, cached_response)
        response = cached_response

      # If we have a cached response, and it doesn't need revalidation, just use it
      else
        response = cached_response

      end

      response
    end

  end

end

