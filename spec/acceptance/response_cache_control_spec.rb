require 'spec_helper'

describe Hypercacher, "when Cache-Control header on the response" do

  shared_context "a cacheable response" do

    let(:cache)   { Hypercacher.new }
    let(:request) { Hypercacher::Request.new :get, "http://example.com/index.html", request_headers }
    let(:request_headers) { {} }

    let(:original_response) { Hypercacher::Response.new 200, response_headers }
    let(:cached_response)   { cache.store(request, original_response); cache.fetch(request) }

    context "the original response" do
      subject { original_response }

      it { should be_cacheable }
    end

    context "the cached response" do
      subject { cached_response }

      it { should be_present }

      context "when fresh" do
        it { should be_valid }
      end

      context "when stale" do
        before do
          response_headers.merge!("Expires" => (Time.now - 60).httpdate)
          cached_response.should be_stale
        end
        it { should_not be_valid }
      end
    end

  end

  context "is not present" do
    let(:response_headers) { {} }

    include_context "a cacheable response"

    context "when an Authorization header is present" do
      before { request_headers.merge!("Authorization" => "Basic foo:bar") }
      subject { original_response }
      it { should_not be_cacheable }
    end

  end

  context 'is "public"' do
    let(:response_headers) { {"Cache-Control" => "public"} }

    include_context "a cacheable response"

    context "when an Authorization header is present" do
      before { request_headers.merge!("Authorization" => "Basic foo:bar") }
      subject { original_response }
      it { should be_cacheable }
    end
  end

  context 'is "private"' do
    let(:response_headers) { {"Cache-Control" => "private"} }

    include_context "a cacheable response"

  end
end

