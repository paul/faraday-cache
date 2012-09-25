require 'sinatra/base'

module AppHelpers

  module ClassMethods

    class App < Sinatra::Base

      #use Rack::CommonLogger, STDOUT

      before do
        response['Date'] = Time.now.httpdate
      end

      def self.request_counts
        @request_counts ||= Hash.new { |hsh,k| hsh[k] = 0 }
      end

      def self.reset_counts!
        @request_counts = nil
      end

      after do
        self.class.request_counts[request.path_info] += 1
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

  RSpec::Matchers.define(:have_received) do |count|
    chain(:request)  { @suffix = "request"  }
    chain(:requests) { @suffix = "requests" }

    description do
      "have received #{count} #{@suffix}"
    end

    def actual_requests
      app.request_counts.values.inject(&:+)
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

