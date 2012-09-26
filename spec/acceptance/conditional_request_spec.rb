require 'spec_helper'

describe Hypercacher, "Conditional requests" do

  context "not handled by the server" do

    app do
      get "/conditional-get/not-supported" do
        "<h1>HuhWhat</h1>"
      end
    end

    before do
      2.times { get "/conditional-get/not-supported" }
    end

    it_behaves_like "second response served from cache"

    context "the first response" do
      subject { responses.first }
      it { should_not have_header("ETag") }
      it { should_not have_header("Last-Modified") }
    end

    context "the second request" do
      subject { requests.last }

      it { should_not have_header("If-None-Match") }
      it { should_not have_header("If-Modified-Since") }
    end

  end

  context "by ETag/If-None-Match" do
    app do
      get "/conditional-get/etag" do
        cache_control :must_revalidate
        etag "1234"
        "<h1>Response with an ETag</h1>"
      end
    end

    before do
      2.times { get "/conditional-get/etag" }
    end

    it_behaves_like "second response needs revalidation"

    context "the second request" do
      subject { requests.last }
      it { should have_header("If-None-Match") }
    end

    context "the second response" do
      subject { responses[1] }
      it { should be_revalidated }
      its(:body) { should_not be_empty }
      # TODO The cached response should be updated (Date, request time, etc...)
      # This is needed to reset the expiration time, so that after the first time
      # has elapsed, we don't always revalidate every request after it.
    end

  end

  context "by Last-Modified/If-Modified-Since" do
    app do
      get "/conditional-get/last-modified" do
        cache_control :must_revalidate
        last_modified Time.utc(2012, 10, 1, 0, 0, 0)
        "<h1>Response with an Last-Modified</h1>"
      end
    end

    before do
      2.times { get "/conditional-get/last-modified" }
    end

    it_behaves_like "second response needs revalidation"

    context "the second request" do
      subject { requests.last }
      it { should have_header("If-Modified-Since") }
    end

    context "the second response" do
      subject { responses[1] }
      it { should be_revalidated }
      its(:body) { should_not be_empty }
      # TODO The cached response should be updated (Date, request time, etc...)
      # This is needed to reset the expiration time, so that after the first time
      # has elapsed, we don't always revalidate every request after it.
    end

  end

end

