ActiveRecord::Migrator.migrations_paths << File.expand_path('../db/migrate', __FILE__)
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
ActiveRecord::Migration.maintain_test_schema!

class ActiveRecord::Base
  include GlobalID::Identification unless ancestors.include?(GlobalID::Identification)
end
