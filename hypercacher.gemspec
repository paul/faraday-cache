# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hypercacher/version"

Gem::Specification.new do |s|
  s.name        = "hypercacher"
  s.version     = Hypercacher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "hypercacher"

  s.add_development_dependency "rspec", ">=2.11.0"
  s.add_development_dependency "autotest"
  s.add_development_dependency "turnip"
  s.add_development_dependency "sinatra"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "awesome_print"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
