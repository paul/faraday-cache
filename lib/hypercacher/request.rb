class Hypercacher
  class RequestWrapper

    def self.new(requestlike)
      # Detect what real wrapper to use, but not if we're in one of our subclasses
      if self != RequestWrapper
        super
      else
        case requestlike
        when Rack::Request
          RackRequestWrapper.new(requestlike)
        when Hash
          if requestlike.has_key? 'rack.version'
            RackEnvWrapper.new(requestlike)
          end
        else
          raise Hypercacher::UnsupportedAdapter, "Don't know how to wrap #{requestlike.inspect}"
        end
      end
    end

    CACHEABLE_METHODS = %w[GET HEAD]

    attr_reader :request

    def initialize(requestlike)
      @request = requestlike
    end

    def original_request
      @request
    end

    def uri
      raise "please implement #uri for #{self.class}"
    end

    def cacheable?
      cacheable_method? # &&
        # ! header.cache_control?.no_store? &&
        # ! header.pragma?.no_cache?
    end

    def cacheable_method?
      CACHEABLE_METHODS.include? method
    end

    class RackRequestWrapper < RequestWrapper

      def uri
        [request.scheme, '://', request.host_with_port, request.path_info].join

      end
    end

    class RackEnvWrapper < RackRequestWrapper

      def initialize(env)
        @original_request = env
        @request = Rack::Request.new(env)
      end

      def original_request
        @original_request
      end


    end
  end
end

