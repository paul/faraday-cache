module FaradayHelpers

  module ExampleGroupMethods
    def request(&block)
      define_method(:make_request) do
        @last_response = instance_eval &block
      end
    end

  end

  module ExampleMethods

    def conn
      @conn ||= Faraday.new do |conn|
        conn.request :hypercacher, Hypercacher.new
        conn.adapter :rack, app
      end
    end

    def get(*args)
      @last_response = conn.get(*args)
    end

    def response
      @last_response ||= make_request
    end

  end

  def self.included(mod)
    mod.extend ExampleGroupMethods
    mod.send :include, ExampleMethods
  end

  RSpec.configure do |c|
    c.include self
  end
end

