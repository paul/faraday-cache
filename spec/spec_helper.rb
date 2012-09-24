
require 'awesome_print'

require 'rack/test'
require 'delorean'

$LOAD_PATH << File.expand_path("../../lib/hypercacher", __FILE__)
require "hypercacher"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Delorean

  config.before :each do
    app.reset_counts!
  end

  config.after :each do
    back_to_the_present
  end
end

Dir.glob("spec/**/support/**/*.rb") { |f| load f, true }


