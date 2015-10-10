system 'rm spec/db/test.sqlite3 &> /dev/null'
system 'mysqladmin -u root drop coupons_test --force &> /dev/null'
system 'mysqladmin -u root create coupons_test --default-character-set=utf8'
system 'dropdb coupons_test &> /dev/null; createdb coupons_test'

ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
ActiveRecord::Migration.maintain_test_schema!

class ActiveRecord::Base
  include GlobalID::Identification unless ancestors.include?(GlobalID::Identification)
end
