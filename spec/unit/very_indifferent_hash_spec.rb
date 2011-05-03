require File.expand_path(File.join(File.dirname(__FILE__), '../..', 'lib/hypercacher'))

describe Hypercacher::Header do

  describe "accessing" do

    before do
      @header = Hypercacher::Header.new :host => "example.com"
    end

    it 'should be accessible by method' do
      @header.host.should == "example.com"
    end

    it 'should return nil for keys that don\'t exist' do
      @header.cache_control.should == nil
    end

    it 'should be an empty HeaderValue when using ?' do
      @header.cache_control?.should == ""
      @header.cache_control?.should be_a(Hypercacher::HeaderValue)
    end

  end


end
