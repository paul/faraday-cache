require 'hypercacher/header'
require 'hypercacher/request'
require 'hypercacher/response'
require 'hypercacher/memory_store'

class Hypercacher

  Error              = Class.new StandardError
  UnsupportedAdapter = Class.new Error

  attr_reader :backend

  def initialize(options = {})
    @backend = options[:backend] || MemoryStore.new(options)
  end

  # Store the response for a request. Supports a variety of "requestlike"
  # and "responselike" objects, see Request.new and Response.new for details
  def store(requestlike, responselike)
    request  = RequestWrapper.new(requestlike)
    response = ResponseWrapper.new(responselike)

    backend.store(request, response)
  end

  def fetch(requestlike)
    request = RequestWrapper.new(requestlike)
    backend.fetch(request)
  end

  def invalidate(uri_or_requestlike)

  end

  protected


end
