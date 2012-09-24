require 'sinatra/base'

module AppHelpers

  module ClassMethods

    class App < Sinatra::Base

      #use Rack::CommonLogger, STDOUT

      def self.request_counts
        @request_counts ||= Hash.new { |hsh,k| hsh[k] = 0 }
      end

      def self.reset_counts!
        @request_counts = nil
      end

      def self.total_requests
        request_counts.values.inject(&:+)
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

end

RSpec.configure do |c|
  c.include AppHelpers
  c.extend AppHelpers::ClassMethods
end

