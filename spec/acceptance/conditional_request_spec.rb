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
      it { should_not have_header("If-Not-Modified") }
    end

  end

end

