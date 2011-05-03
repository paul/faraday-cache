class Hypercacher
  QMARK_ENDING = /\?$/
  class Header

    def initialize(headers)
      @headers = {}
      headers.each_pair do |key, value|
        @headers[convert_key(key)] = value
      end
    end

    def method_missing(method, *a, &b)
      token = convert_key(method)
      if token =~ QMARK_ENDING
        token = token.chomp('?')
        HeaderValue.new(@headers[token] || "")
      elsif @headers.has_key? token
        HeaderValue.new(@headers[token])
      else
        nil
      end
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

  class HeaderValue < String
    def initialize(string)
      super(string) unless string.nil?
    end

    def method_missing(method, *a, &b)
      if method.to_s =~ QMARK_ENDING
        token = method.to_s.chomp('?')
        instance_eval <<-CODE, __FILE__, __LINE__
          def #{method}
            include?("#{token}")
          end
        CODE
        send(method)
      else
        super
      end
    end
  end

end

