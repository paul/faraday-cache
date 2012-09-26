# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "faraday-cache"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Sadauskas"]
  s.email       = ["psadauskas@gmail.com"]
  s.homepage    = "https://github.com/paul/faraday-cache"
  s.summary     = %q{A client cache middleware for Faraday}
  s.description = %q{HTTP Cache}

  s.rubyforge_project = "faraday-cache"

  s.add_dependency "faraday"

  s.add_development_dependency "rspec", ">=2.11.0"
  s.add_development_dependency "delorean"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "awesome_print"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
