class Hypercacher
  class Response

    def initialize(*args)
      if args.last.is_a?(Hash)
        @response_hash = args.pop.dup
      end
    end

    def status
      @status ||=
        begin
          if @response_hash
            @response_hash[:status]
          end
        end
    end

    def header
      @header ||= Header.new(
        if @response_hash
          @response_hash[:headers]
        end
      )
    end

    def successful?
      (200..299).include? status
    end

  end
end

