require 'net/http'

step "I have configured Hypercacher to use the heap store" do
  @cache = Hypercacher.new
end

step "there is an action:" do |code|
  app.class_eval code
end

step "I make a request to :path" do |path|
  response = get path
end

step "I make another request to :path within :n seconds" do |path, interval|
  response = get path
end

step "there should only have been 1 request made to :path" do |path|
  app.response_counts[path].should == 1
end

