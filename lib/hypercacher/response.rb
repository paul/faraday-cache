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
      return true if cache_control_max_age && current_age > cache_control_max_age
      return true if expires && at > expires
      false
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
      if cache_control
        cache_control[/max-age=(\d+)/].first.to_i
      else
        nil
      end
    end

    def expires
      if headers['Expires']
        Time.httpdate(headers['Expires'])
      else
        nil
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

    def cache_control # TODO replace this with a smart object
      headers['Cache-Control']
    end

  end

  class CachedResponse < Faraday::Response

    def authoritative?
      # Responses from the cache are never authoritative
      false
    end
  end
end


