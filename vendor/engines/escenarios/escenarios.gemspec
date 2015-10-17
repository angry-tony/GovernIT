$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "escenarios/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "escenarios"
  s.version     = Escenarios::VERSION
  s.authors     = ["Sebastian Lesmes Alvarado"]
  s.email       = ["slesmes1992@gmail.com"]
  s.homepage    = ""
  s.summary     = "InvestIT - Modulo de Escenarios de Evaluacion"
  s.description = "InvestIT - Modulo de Escenarios de Evaluacion"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
end
