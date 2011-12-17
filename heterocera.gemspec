# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heterocera/version"

Gem::Specification.new do |s|
  s.name        = "heterocera"
  s.version     = Heterocera::VERSION
  s.authors     = ["Dave ten Have"]
  s.email       = ["david@ponoko.com"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""

  s.rubyforge_project = "heterocera"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "mechanize"
end
