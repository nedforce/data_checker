$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'data_checker/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'data_checker'
  s.version     = DataChecker::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nedforce Informatica Specialisten']
  s.email       = ['info@nedforce.nl']
  s.homepage    = 'http://www.nedforce.nl'
  s.summary     = 'DataChecker'
  s.description = 'DataChecker'

  s.files = Dir["{app,config,db,lib}/**/*"] + ['LICENSE', 'Rakefile']
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.0'
  s.add_dependency 'nokogiri'

  s.add_development_dependency 'mocha'
  s.add_development_dependency 'test-unit'
end
