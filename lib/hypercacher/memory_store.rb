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
      @data_store[request.uri] = response
    end

    def fetch(request)
      @data_store[request.uri]
    end

    class CacheCollection


    end

  end
end

