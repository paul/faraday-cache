require 'sinatra/base'

module AppHelpers

  class App < Sinatra::Base

    def self.response_counts
      @response_counts ||= Hash.new { |hsh,k| hsh[k] = 0 }
    end

    after do
      self.class.response_counts[request.path_info] += 1
    end

  end

  def app
    App
  end

end

puts "Required #{__FILE__}"
RSpec.configure do |c|
  c.include AppHelpers
end

