module CacheHelpers

  # Add #env_for to the available Rack::Test::Methods
  extend Forwardable
  def_delegators :current_session, :env_for, :process_request

  def get(uri, params = {}, env = {}, &block)
    env = env_for(uri, env.merge(:method => "GET", :params => params))

    cached_response = @cache.fetch(env)

    if cached_response.nil? || cached_response.stale?
      process_request(uri, env, &block)
    else
      @last_response = cached_response
    end

    @cache.store(last_request, last_response)
  end

  RSpec::Matchers.define :be_present do
    match do |obj|
      !obj.nil?
    end
  end

  RSpec.configure { |c| c.include self }


end

