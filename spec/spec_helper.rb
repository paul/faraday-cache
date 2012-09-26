
require 'awesome_print'

require 'rack/test'
require 'delorean'

$LOAD_PATH << File.expand_path("../../lib/", __FILE__)
require "faraday/cache"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Delorean

  config.before :each do
    app.reset_requests!
  end

  config.after :each do
    back_to_the_present
  end
end

Dir.glob("spec/**/support/**/*.rb") { |f| load f, true }


