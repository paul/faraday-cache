require 'hypercacher/faraday_middleware'
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

  def store(request, response)
    backend.store(request, response) if response.cacheable?
  end

  def fetch(request)
    backend.fetch(request)
  end

  def invalidate(request)

  end

  def set_conditional_headers!(request)

  end


end
