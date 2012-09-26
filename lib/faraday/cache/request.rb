class Faraday::Cache
  class Request < Faraday::Request

    CACHEABLE_METHODS = [:get, :head]

    attr_reader :request

    def self.from_env(env)
      new(env,
          env[:method],
          env[:url].to_s,
          env[:params],
          env[:request_headers],
          env[:body],
          env[:request]
         )
    end

    def initialize(*a)
      @original_env = a.shift
      super(*a)
    end

    def cacheable?
      cacheable_method? # &&
        # ! header.cache_control?.no_store? &&
        # ! header.pragma?.no_cache?
    end

    def cacheable_method?
      CACHEABLE_METHODS.include? method
    end

    def to_env
      @original_env.merge(:request_headers => headers)
    end

  end
end

