$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'opencnam'
require 'rspec'

# Load fixtures
load File.join(File.dirname(__FILE__), 'fixtures', 'opencnam_ok_response.rb')
load File.join(File.dirname(__FILE__), 'fixtures', 'opencnam_bad_response.rb')

RSpec.configure do |config|
  config.mock_with :rspec
end
