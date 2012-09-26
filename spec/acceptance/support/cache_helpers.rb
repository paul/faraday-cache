module CacheHelpers

  RSpec::Matchers.define(:be_from_cache) do
    match do |response|
      !response.authoritative?
    end
  end

  RSpec::Matchers.define(:have_header) do |name|
    match do |request_or_response|
      !headers(request_or_response)[name].nil?
    end

    failure_message_for_should do |request_or_response|
      "Expected #{name.inspect} header to be in #{PP.pp(headers(request_or_response), "")}"
    end

    def headers(request_or_response)
      case request_or_response
      when Faraday::Response
        request_or_response.headers
      when Sinatra::Request
        request_or_response.env.inject({}) do |h,(k,v)|
          if k =~ /^HTTP_/
            h[k.gsub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')] = v
          end
          h
        end
      else
        raise "I don't know how to find headers in #{request_or_response.inspect}"
      end
    end
  end

  shared_examples_for "second response served from cache" do
    context "the first response" do
      subject { responses.first }
      it { should_not be_from_cache }
    end

    context "the second response" do
      subject { responses.last }
      it { should be_from_cache }
    end

    context "the remote server" do
      subject { app }
      it { should have_received(1).request }
    end
  end

  shared_examples_for "second response needs revalidation" do
    context "the first response" do
      subject { responses.first }
      it { should_not be_from_cache }
    end

    context "the second response" do
      subject { responses.last }
      it { should_not be_from_cache }
    end

    context "the remote server" do
      subject { app }
      it { should have_received(2).requests }
    end
  end


  RSpec.configure { |c| c.include self }

end

