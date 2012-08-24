class Hypercacher
  class Header

    def initialize(headers = {})
      @headers = {}
      headers.each_pair do |key, value|
        @headers[convert_key(key)] = value
      end
    end

    def method_missing(method, *a, &b)
      if @headers.respond_to?(method)
        @headers.send(method, *a.unshift(convert_key(a.shift)), &b)
      else
        super
      end
    end

    def respond_to?(*a)
      @headers.respond_to?(*a) || super
    end

    protected

    def convert_key(key)
      key.
        to_s.
        gsub(RACK_HEADER_PREFIX, '').
        gsub('-', '_').
        downcase
    end

    RACK_HEADER_PREFIX = /^HTTP_/
  end

end

