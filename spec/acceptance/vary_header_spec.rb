require 'spec_helper'

describe Hypercacher, "with a Vary header" do

  subject { response }

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

    it { should be_ok }
    it { should_not be_authoritative }

    describe "the remote server" do
      subject { app }
      it { should have_received(1).request }
    end

  end

  context "is '*'" do
    app do
      get "/vary/star" do
        response["Vary"] = "*"
        "<h1>Vary on Everything</h1>"
      end
    end

    before do
      get "/vary/star", nil, "Accept" => "text/html"
      get "/vary/star", nil, "Accept" => "text/html"
    end

    it { should be_ok }
    it { should be_authoritative }

    describe "the remote server" do
      subject { app }
      it { should have_received(2).requests }
    end
  end

  context "when all of the request headers match" do
    app do
      get "/vary/match" do
        response["Vary"] = "Accept, Accept-Encoding"
        "<h1>Vary on Accept</h1>"
      end
    end

    before do
      get "/vary/match", nil, "Accept" => "text/html", "Accept-Encoding" => "compress"
      get "/vary/match", nil, "Accept" => "text/html", "Accept-Encoding" => "compress"
    end

    it { should be_ok }
    it { should_not be_authoritative }

    describe "the remote server" do
      subject { app }
      it { should have_received(1).requests }
    end
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

    it { should be_ok }
    it { should be_authoritative }

    describe "the remote server" do
      subject { app }
      it { should have_received(2).requests }
    end
  end

end

