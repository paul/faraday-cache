class Hypercacher

  def initialize(backend, options = {})

  end

  # Store the response for this request. There are two different ways to call this method.
  #
  # (see #store_rack_env) (see #store_uri)
  def store(*args)
    if args.first.is_a? String
      store_uri *args
    else
      store_rack_env *args
    end
  end

  # Store a response for the request
  #
  # @param [Hash] request_env    A hash expected to conform to the
  #   Rack Environment specification {http://rack.rubyforge.org/doc/files/SPEC.html}
  # @param [Hash] response       A hash with three keys:
  #  * `:status`  the status code
  #  * `:headers` case-insensitive response headers
  #  * `:body`    the response body
  def store_rack_env(request_env, response)
    store_uri uri_from_rack_env(request_env), normalize_rack_headers(request_env), response
  end

  def store_uri(uri, request_headers, response)

  end

  def fetch(request_or_uri, request_headers)

  end

  def invalidate(uri_or_request)

  end

  protected

  def uri_from_rack_env(env)
    parts = []

    scheme = env['rack.url_scheme']
    parts << scheme << "://"
    parts << env['HTTP_HOST'] || env['SERVER_NAME']

    port = env['SERVER_PORT']
    if scheme == "https" && port != 443 ||
       scheme == "http" && port != 80
      parts << ":" << @request.port.to_s
    end

    parts << env['SCRIPT_NAME']
    parts << env['PATH_INFO']

    if qs = env['QUERY_STRING']
      parts << "?"
      parts << qs
    end

    parts.join
  end

  def normalize_rack_headers(env)
    headers = {}

    env.each do |key, value|
      next unless key =~ /^HTTP_/
      headers[key.gsub(/^HTTP_/,'')] = value
    end

    headers
  end

end
