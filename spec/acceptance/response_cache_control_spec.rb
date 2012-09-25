require 'spec_helper'

describe Hypercacher, "with a Cache-Control header" do

  shared_examples_for "a cacheable response" do
    describe "the first request"  do
      before { make_request }

      it { should be_ok }
      it { should be_authoritative }
    end

    describe "the second request" do
      before do
        2.times { make_request }
      end

      it { should be_ok }
      it { should_not be_authoritative }

      describe "the remote server" do
        subject { app }
        it { should have_received(1).request }
      end
    end
  end

  shared_examples_for "a response that needs revalidation" do

    describe "the second request" do
      before do
        2.times { make_request }
      end

      it { should be_ok }
      it { should be_authoritative }

      describe "the remote server" do
        subject { app }
        it { should have_received(2).requests }
      end
    end
  end

  subject { response }

  context "not present" do
    app do
      get "/cache-control/none" do
        response['Cache-Control'] = nil
        "<h1>No Cache-Control set</h1>"
      end
    end

    request { get "/cache-control/none" }

    it_behaves_like "a cacheable response"

  end

  context "private (this is a private cache, so we may cache it" do

    app do
      get "/cache-control/private" do
        cache_control :private
        "<h1>Cache-Control: private</h1>"
      end
    end

    request { get "/cache-control/private" }

    it_behaves_like "a cacheable response"

  end

  context "public" do

    app do
      get "/cache-control/public" do
        cache_control :public
        "<h1>Cache-Control: public</h1>"
      end
    end

    request { get "/cache-control/public" }

    it_behaves_like "a cacheable response"

  end

  context "must-revalidate" do

    app do
      get "/cache-control/must-revalidate" do
        cache_control :public, :must_revalidate
        "<h1>Cache-Control: must-revalidate"
      end
    end

    request { get "/cache-control/must-revalidate" }

    it_behaves_like "a response that needs revalidation"

  end

  context "no-cache" do

    app do
      get "/cache-control/no-cache" do
        cache_control :no_cache
        "<h1>Cache-Control: no-cache"
      end
    end

    request { get "/cache-control/no-cache" }

    it_behaves_like "a response that needs revalidation"

  end

  context "max-age" do

    app do
      get "/cache-control/max-age" do
        cache_control :public, :max_age => 60
        "<h1>Cache-Control: max-age=60</h1>"
      end
    end

    request { get "/cache-control/max-age" }

    describe "a request made within max-age" do
      before do
        make_request
        jump 30
        make_request
      end

      it { should be_ok }
      it { should_not be_authoritative }

      describe "the remote server" do
        subject { app }
        it { should have_received(1).request }
      end
    end

    describe "a request made after max-age" do
      before do
        make_request
        jump 90
        make_request
      end

      it { should be_ok }
      it { should be_authoritative }

      describe "the remote server" do
        subject { app }
        it { should have_received(2).requests }
      end
    end

  end

end

