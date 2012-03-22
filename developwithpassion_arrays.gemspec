# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib",__FILE__)
require "developwithpassion_arrays/version"

Gem::Specification.new do |s|
  s.name        = "developwithpassion_arrays"
  s.version     = DevelopWithPassion::Arrays::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Develop With Passion®"]
  s.email       = ["open_source@developwithpassion.com"]
  s.homepage    = "http://www.developwithpassion.com"
  s.summary     = %q{Simple DSL For Declaritive Arrays}
  s.description = %q{Simple DSL For Declaritive Arrays}
  s.rubyforge_project = "developwithpassion_arrays"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "developwithpassion_fakes"
end
