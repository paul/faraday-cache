require 'time'

class Hypercacher
  class ResponseWrapper

    def self.new(responselike)
      # Detect what real wrapper to use, but not if we're in one of our subclasses
      if self != ResponseWrapper
        super
      else
        case responselike
        when Rack::MockResponse
          RackMockResponseWrapper.new(responselike)
        else
          raise Hypercacher::UnsupportedAdapter, "Don't know how to wrap #{responselike.inspect}"
        end
      end
    end

    def initialize(responselike)
      @response = @original_response = responselike
    end

    def response
      @response
    end

    def fresh?(at = Time.now)
      if header.has_key?("Expires")
        Time.httpdate(header["Expires"]) > at
      else
        true
      end
    end

    def stale?(at = Time.now)
      !fresh?(at)
    end

    def successful?
      (200..299).include? status
    end

    def cacheable?
      true
    end

    def needs_revalidation?
      stale?
    end

    def valid?
      !needs_revalidation?
    end

    class RackMockResponseWrapper < ResponseWrapper

      def header
        response.header
      end

    end

  end
end

