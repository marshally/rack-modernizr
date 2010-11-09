# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack-modernizr/version"

Gem::Specification.new do |s|
  s.name        = "rack-modernizr"
  s.version     = Modernizr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marshall Yount"]
  s.email       = ["marshall@yountlabs.com"]
  s.homepage    = "http://rubygems.org/gems/rack-modernizr"
  s.summary     = %q{a Rack middleware that brings the power of the Modernizr javascript framework server-side}
  s.description = %q{Rack::Modernizr is a Rack middleware that automagically includes the Modernizr javascript framework and exposes the results to your server-side scripts.}

  s.rubyforge_project = "rack-modernizr"

  s.add_dependency 'rack'
  s.add_development_dependency 'test-spec', '>= 0.9.0'
  s.add_development_dependency 'test-unit'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
