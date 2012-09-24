require 'sinatra/base'

module AppHelpers

  module ClassMethods

    class App < Sinatra::Base

      #use Rack::CommonLogger, STDOUT

      def self.response_counts
        @response_counts ||= Hash.new { |hsh,k| hsh[k] = 0 }
      end

      def self.reset_counts!
        @response_counts = nil
      end

      after do
        self.class.response_counts[request.path_info] += 1
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

