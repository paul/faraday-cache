require 'time'

class Hypercacher
  module Response
    # Monkeypatch Faraday::Response with caching utility methods
    Faraday::Response.send(:include, self)

    attr_reader :response_time

    def initialize(env = nil)
      @response_time = Time.now
      super
    end

    def response_time
      @response_time || Time.now
    end

    def request_time
      env["request_time"] || Time.now
    end

    def expired?(at = Time.now)
      [
        current_age > cache_control_max_age,
        at > expires
      ].any?
    end

    def stale?
      expired?
    end

    def authoritative?
      # Responses coming from Faraday are always authoritative
      true
    end

    # Algorithm directly from RFC2616#13.2.3
    def current_age(at = Time.now)
      age_value = headers['age'].to_i
      date_value = headers['Date'] ? Time.httpdate(headers['Date']) : Time.at(0)
      now = at

      apparent_age = [0, response_time - date_value].max
      corrected_received_age = [apparent_age, age_value].max
      current_age = corrected_received_age + (response_time - request_time) + (now - response_time)
    end

    def cache_control_max_age
      if headers['Cache-Control']
        headers['Cache-Control'][/max-age=(\d+)/][0].to_i
      else
        0
      end
    end

    def expires
      if headers['Expires']
        Time.httpdate(headers['Expires'])
      else
        Time.now
      end
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

  end

  class CachedResponse < Faraday::Response

    def authoritative?
      # Responses from the cache are never authoritative
      false
    end
  end
end


