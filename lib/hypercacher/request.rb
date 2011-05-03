class Hypercacher
  class Request

    CACHEABLE_METHODS = %w[GET HEAD]

    def initialize(*args)
      if args.last.is_a?(Hash)
        @request_hash = args.pop.dup
      end

    end

    # HTTP Request method
    # @ return [String] the HTTP request method, all caps
    def method
      @method ||=
        begin
          if @request_hash
            @request_hash[:method].to_s.upcase
          end
        end
    end

    # HTTP Request header, as an nice-to-use object
    # @return [Hypercacher::Headers]
    def header
      @header ||= Header.new(
        if @request_hash
          @request_hash[:headers]
        end
      )
    end

    # HTTP Request URI
    # @return [String] the uri
    def uri
      @uri ||=
        begin
          if @request_hash
            @request_hash[:uri]
          end
        end
    end

    def cacheable?
      cacheable_method? &&
        ! header.cache_control?.no_store? &&
        ! header.pragma?.no_cache?
    end


    protected

    def cacheable_method?
      CACHEABLE_METHODS.include? method
    end


  end
end

