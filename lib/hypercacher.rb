
require 'hypercacher/request'
require 'hypercacher/header'

class Hypercacher

  def initialize(backend, options = {})

  end

  # Store the response for a request. Supports a variety of "requestlike"
  # and "responselike" objects, see Request.new and Response.new for details
  def store(requestlike, responselike)
    request = Request.new requestlike
    response = Response.new responselike

    backend.store(request, response)
  end

  def fetch(requestlike)
    request = Request.new requestlike
    backend.fetch(request)
  end

  def invalidate(uri_or_requestlike)

  end

  protected

end
