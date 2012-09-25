module CacheHelpers

  RSpec::Matchers.define(:be_from_cache) do
    match do |response|
      !response.authoritative?
    end
  end

  RSpec::Matchers.define(:have_header) do |name|
    match do |request_or_response|
      case request_or_response
      when Faraday::Response
        !request_or_response.headers[name].nil?
      when Sinatra::Request
        !request_or_response[name].nil?
      else
        raise "I don't know how to find headers in #{request_or_response.inspect}"
      end
    end
  end

  RSpec.configure { |c| c.include self }

end

