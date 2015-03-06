require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/application'
require 'rspec/rails'
require 'coupons'

ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.infer_spec_type_from_file_location!
end
