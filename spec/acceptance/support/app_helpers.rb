require 'sinatra/base'

module AppHelpers

  module ClassMethods

    class App < Sinatra::Base

      #use Rack::CommonLogger, STDOUT

      before do
        response['Date'] = Time.now.httpdate
      end

      def self.requests
        @requests ||= []
      end

      def self.reset_requests!
        @requests = nil
      end

      after do
        self.class.requests << request
      end

    end

    def app(&b)
      @app ||= App
      @app.class_eval(&b) if block_given?
      @app
    end

  end

  def app
    self.class.app
  end

  def requests
    app.requests
  end

  RSpec::Matchers.define(:have_received) do |count|
    chain(:request)  { @suffix = "request"  }
    chain(:requests) { @suffix = "requests" }

    description do
      "have received #{count} #{@suffix}"
    end

    def actual_requests
      app.requests.size
    end

    match do
      actual_requests == count
    end

    failure_message_for_should do
      "expected #{count} #{@suffix}, but received #{actual_requests}"
    end
  end

end

RSpec.configure do |c|
  c.include AppHelpers
  c.extend AppHelpers::ClassMethods
end

