$:.unshift File.expand_path('../lib', __FILE__)
require 'opencnam/version'

Gem::Specification.new do |s|
  s.name        = 'opencnam'
  s.version     = Opencnam::VERSION
  s.homepage    = 'http://github.com/nysa/ruby-opencnam'
  s.summary     = 'Ruby bindings for the OpenCNAM API'
  s.description = 'OpenCNAM provides a simple, elegant, and RESTful API to get Caller ID data.'
  s.license     = 'MIT'
  s.author      = 'Nysa Vann'
  s.email       = 'nysa@nysavann.com'
  s.files       = Dir['LICENSE', 'README.md', 'lib/**/*.rb']
  s.test_files  = Dir.glob('spec/**/*')

  s.add_dependency 'json', '~> 1.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.14'
end
