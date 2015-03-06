require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/application'
require 'rspec/rails'
require 'coupons'
require 'generator_spec'
require 'generators/coupons/install/install_generator'

ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)
ActiveRecord::Migrator.migrate('./db/migrate') if ActiveRecord::Migrator.needs_migration?
ActiveRecord::Migration.maintain_test_schema!

Dir['./spec/support/**/*.rb'].each do |file|
  require file
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.infer_spec_type_from_file_location!
  config.include Helpers
end
