
require 'awesome_print'

require 'rack/test'

$LOAD_PATH << File.expand_path("../../lib/hypercacher", __FILE__)
require "hypercacher"

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

Dir.glob("spec/**/support/**/*.rb") { |f| load f, true }


