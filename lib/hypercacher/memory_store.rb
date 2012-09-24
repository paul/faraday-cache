class Hypercacher
  class AbstractStore
    def initialize(options = {})
    end


  end

  class MemoryStore < AbstractStore

    def initialize(options = {})
      super
      @data_store = {}
    end

    def store(request, response)
      @data_store[request.path] = response.env
    end

    def fetch(request)
      resp = @data_store[request.path]
      if resp
        CachedResponse.new(resp)
      else
        nil
      end
    end

    class CacheCollection


    end

  end
end

