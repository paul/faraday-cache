require 'spec_helper'

describe Hypercacher, "response Cache-Control header" do

  context "is missing" do

    app do
      get "/cache-control/none" do
        "<h1>No Cache-Control set</h1>"
      end
    end

    request do
      get "/cache-control/none"
    end

    subject { response }

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
    end

  end


end

