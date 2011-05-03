require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib/hypercacher'))

describe Hypercacher::Request do

  subject { @request }

  describe ".new" do

    describe "from a hash" do

      before do
        @request = new_request :method => :get
      end

      its(:method) { should == "GET" }
    end
  end

  describe "#cacheable?" do

    context "when request method is cacheable" do
      before do
        @request = new_request :method => :get
      end

      it { should be_cacheable }
    end

    context "when request method is not cacheable" do
      before do
        @request = new_request :method => :post
      end

      it { should_not be_cacheable }
    end
  end

  def new_request(params)
    default_params = {
      :method => :get,
      :headers => {
        'Host' => 'example.com'
      },
      :body => nil
    }

    @request = Hypercacher::Request.new default_params.merge(params)
  end
end

