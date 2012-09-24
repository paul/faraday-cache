require 'net/http'

step "I have configured Hypercacher to use the heap store" do
  @cache = Hypercacher.new
end

step "there is an app:" do |code|
  app.class_eval code
end

step "I make a request to :path" do |path|
  response = get path
end

step "I make another request to :path within :n seconds" do |path, interval|
  Delorean.jump interval.to_i - 1
  response = get path
end

step "I make another request to :path after :n seconds" do |path, interval|
  Delorean.jump interval.to_i
  response = get path
end

step "there should (only )have been :count request(s) made to :path" do |count, path|
  app.response_counts[path].should == count.to_i
end

