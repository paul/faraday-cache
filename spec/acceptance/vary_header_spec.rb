require 'spec_helper'

describe Faraday::Cache, "with a Vary header" do

  context "not present" do

    app do
      get "/vary/none" do
        response["Vary"] = nil
        "<h1>No Vary Header</h1>"
      end
    end

    before do
      get "/vary/none", nil, "Accept" => "text/html"
      get "/vary/none", nil, "Accept" => "text/plain"
    end

    it_behaves_like "second response served from cache"
  end

  context "is '*'" do
    app do
      get "/vary/star" do
        response["Vary"] = "*"
        "<h1>Vary on Everything</h1>"
      end
    end

    before do
      2.times { get "/vary/star", nil, "Accept" => "text/html" }
    end

    it_behaves_like "second response needs revalidation"
  end

  context "when all of the request headers match" do
    app do
      get "/vary/match" do
        response["Vary"] = "Accept, Accept-Encoding"
        "<h1>Vary on Accept</h1>"
      end
    end

    before do
      2.times do
      get "/vary/match", nil, "Accept" => "text/html", "Accept-Encoding" => "compress"
      end
    end

    it_behaves_like "second response served from cache"

  end

  context "when one of the request headers change" do
    app do
      get "/vary/match" do
        response["Vary"] = "Accept, Accept-Encoding"
        "<h1>Vary on Accept</h1>"
      end
    end

    before do
      get "/vary/match", nil, "Accept" => "text/html", "Accept-Encoding" => "compress"
      get "/vary/match", nil, "Accept" => "text/plain", "Accept-Encoding" => "compress"
    end

    it_behaves_like "second response needs revalidation"

  end

end

