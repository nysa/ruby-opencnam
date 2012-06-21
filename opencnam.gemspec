$:.unshift File.expand_path("../lib", __FILE__)
require 'opencnam/version'

spec = Gem::Specification.new do |s|
  s.name = 'opencnam'
  s.version = OpenCNAM::VERSION

  s.homepage = 'http://github.com/nysa/ruby-opencnam'
  s.summary = 'Ruby bindings for the OpenCNAM API'
  s.description = 'OpenCNAM provides a simple, elegant, and RESTful API to get Caller ID data.'

  s.author = 'Nysa Vann'
  s.email = 'nysa@nysavann.com'

  s.add_development_dependency "fakeweb",  "~> 1.3"
  s.add_development_dependency "minitest", "~> 3.1.0"
  s.add_development_dependency "rake"

  s.files = Dir["lib/**/*.rb"]
end
