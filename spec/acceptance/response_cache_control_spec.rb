require 'spec_helper'

describe Faraday::Cache, "with a Cache-Control header" do

  context "not present" do
    app do
      get "/cache-control/none" do
        response['Cache-Control'] = nil
        "<h1>No Cache-Control set</h1>"
      end
    end

    before do
      2.times { get "/cache-control/none" }
    end

    it_behaves_like "second response served from cache"

  end

  context "private (this is a private cache, so we may cache it" do

    app do
      get "/cache-control/private" do
        cache_control :private
        "<h1>Cache-Control: private</h1>"
      end
    end

    before do
      2.times { get "/cache-control/private" }
    end

    it_behaves_like "second response served from cache"

  end

  context "public" do

    app do
      get "/cache-control/public" do
        cache_control :public
        "<h1>Cache-Control: public</h1>"
      end
    end

    before do
      2.times { get "/cache-control/public" }
    end

    it_behaves_like "second response served from cache"

  end

  context "must-revalidate" do

    app do
      get "/cache-control/must-revalidate" do
        cache_control :public, :must_revalidate
        "<h1>Cache-Control: must-revalidate"
      end
    end

    before do
      2.times { get "/cache-control/must-revalidate" }
    end

    it_behaves_like "second response needs revalidation"

  end

  context "no-cache" do

    app do
      get "/cache-control/no-cache" do
        cache_control :no_cache
        "<h1>Cache-Control: no-cache"
      end
    end

    before do
      2.times { get "/cache-control/no-cache" }
    end

    it_behaves_like "second response needs revalidation"

  end

  context "max-age" do

    app do
      get "/cache-control/max-age" do
        cache_control :public, :max_age => 60
        "<h1>Cache-Control: max-age=60</h1>"
      end
    end

    describe "a request made within max-age" do
      before do
        get "/cache-control/max-age"
        jump 30
        get "/cache-control/max-age"
      end

      it_behaves_like "second response served from cache"

    end

    describe "a request made after max-age" do
      before do
        get "/cache-control/max-age"
        jump 90
        get "/cache-control/max-age"
      end

      it_behaves_like "second response needs revalidation"

    end

  end

end

