# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "liboauth/version"

Gem::Specification.new do |s|
  s.name        = "liboauth"
  s.version     = Liboauth::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hirohisa Mitsuishi"]
  s.email       = ["mitsuishi.hirohisa@mountposition.co.jp"]
  s.homepage    = ""
  s.summary     = %q{liboauth wrapper}
  s.description = %q{liboauth wrapper}
  s.extensions = ["ext/liboauth_ext/extconf.rb"]

#  s.rubyforge_project = "liboauth"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "ext"]

  # test
  s.add_development_dependency 'rspec'
end
