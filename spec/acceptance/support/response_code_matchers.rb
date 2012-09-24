module RSpec::Support
  module HttpResponseValidator

    def be_successful
      ResponseCodeMatcher.new(200..299, "Successful")
    end
    alias be_success be_successful

    def be_ok
      ResponseCodeMatcher.new(200, "OK")
    end

    def be_created
      ResponseCodeMatcher.new(201, "Created")
    end

    def be_client_error
      ResponseCodeMatcher.new(400..499, "Client Error")
    end

    def be_unauthorized
      ResponseCodeMatcher.new(401, "Unauthorized")
    end

    def be_forbidden
      ResponseCodeMatcher.new(403, "Forbidden")
    end

    def be_not_found
      ResponseCodeMatcher.new(404, "Not Found")
    end

    def be_method_not_allowed_error
      ResponseCodeMatcher.new(405, "Method Not Allowed")
    end

    def be_not_acceptable_error
      ResponseCodeMatcher.new(406, "Not Acceptable")
    end
    alias be_not_acceptable be_not_acceptable_error

    class ResponseCodeMatcher

      def initialize(code, name)
        @code, @name = code, name
      end

      def matches?(response)
        @response_code = response.status
        if @code.is_a? Range
          @code.include?(@response_code)
        else
          @response_code.to_s == @code.to_s
        end
      end

      def failure_message
        "Expected response to be #{@code} #{@name}, but it was #{@response_code}"
      end

      def negative_failure_message
        "Expected response to not be #{@code} #{@name}, but it was"
      end

      def description
        "be #{@name} (code #{@code.inspect})"
      end

    end

    ::RSpec.configure do |config|
      config.include self
    end
  end

end

