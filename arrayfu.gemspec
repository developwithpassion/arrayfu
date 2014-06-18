# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require "arrayfu/version"

Gem::Specification.new do |s|
  s.name        = "arrayfu"
  s.version     = ArrayFu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Develop With Passion®"]
  s.license     = 'MIT'
  s.email       = ["open_source@developwithpassion.com"]
  s.homepage    = "http://www.developwithpassion.com"
  s.summary     = %q{Simple DSL For Declaritive Arrays}
  s.description = %q{Simple DSL For Declaritive Arrays}
  s.rubyforge_project = "arrayfu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency("rake", "~> 0.9.0")
  s.add_development_dependency("yard", "~> 0.8.7.4")
  s.add_development_dependency("guard", "~> 2.6.1")
  s.add_development_dependency("guard-rspec", "~> 4.2.9")
  s.add_development_dependency("fakes-rspec", "~> 2.0.0")
end
