module FaradayHelpers

  def conn
    @conn ||= Faraday.new do |conn|
      conn.request :cache
      conn.adapter :rack, app
    end
  end

  def get(*args)
    resp = conn.get(*args)
    responses << resp
  end

  def responses
    @responses ||= []
  end

  RSpec.configure { |c| c.include self }
end

