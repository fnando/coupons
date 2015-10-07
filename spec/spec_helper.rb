require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require 'bundler/setup'
require_relative 'dummy/config/application'
require 'rspec/rails'
require 'coupons'
require 'generator_spec'
require 'generators/coupons/install/install_generator'
require 'database_cleaner'

require_relative 'support/active_record'

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.infer_spec_type_from_file_location!
  config.include Helpers

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
    Coupons.configuration = Coupons::Configuration.new
  end
end
