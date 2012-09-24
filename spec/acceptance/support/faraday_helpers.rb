module FaradayHelpers

  module ClassMethods
    def request(&block)
      @@request_action = block
    end

    def request_action
      @@request_action
    end
  end

  def conn
    @conn ||= Faraday.new do |conn|
      conn.request :hypercacher, Hypercacher.new
      conn.adapter :rack, app
    end
  end

  def get(*args)
    conn.get(*args)
  end

  def make_request
    @last_response = instance_eval &self.class.request_action
  end

  def response
    @last_response ||= make_request
  end

  RSpec.configure do |c|
    c.include self
    c.extend self::ClassMethods
  end
end

