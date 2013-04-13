class Faraday::Cache

  class MemoryStore < AbstractStore

    def initialize(options = {})
      super
      @data_store = Hash.new { |h,k| h[k] = [] }
    end

    def store(request, response)
      # First, remove any existing cached responses that could match this request
      # so they will be replaced by this newer response
      @data_store[request.path].delete_if { |e| valid_entry?(e, request) }
      @data_store[request.path] << response.env
    end

    def fetch(request)
      resp = @data_store[request.path].detect { |e| valid_entry?(e, request) }
      if resp
        CachedResponse.new(resp)
      else
        nil
      end
    end

    protected

    def valid_entry?(candidate_env, request)
      return true  unless vary_header = candidate_env[:response_headers]["Vary"]
      return false if vary_header == '*'

      # TODO: handle case, whitespace, multiple fields -- RFC2616#13.6
      vary_header.split(/\s*,\s*/).all? do |name|
        candidate_env[:request_headers][name] == request.headers[name]
      end
    end

  end
end

