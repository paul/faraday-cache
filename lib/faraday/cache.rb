require 'faraday'

require 'faraday/cache/middleware'
require 'faraday/cache/request'
require 'faraday/cache/response'
require 'faraday/cache/abstract_store'
require 'faraday/cache/memory_store'

class Faraday::Cache

  VERSION = '0.0.1'

  Error              = Class.new StandardError
  UnsupportedAdapter = Class.new Error

  attr_reader :backend

  def initialize(options = {})
    @backend = options[:backend] || MemoryStore.new(options)
  end

  def store(request, response)
    backend.store(request, response) if response.cacheable?
  end

  def fetch(request)
    backend.fetch(request)
  end

  def invalidate(request)

  end

  def set_conditional_headers!(request, response)
    if etag = response.headers['ETag']
      request.headers['If-None-Match'] = etag
    end

    if last_modified = response.headers['Last-Modified']
      request.headers['If-Modified-Since'] = last_modified
    end
  end


end
