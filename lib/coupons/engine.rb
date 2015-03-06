module Coupons
  class Railtie < Rails::Engine
    isolate_namespace Coupons

    initializer 'coupons.append_migrations' do |app|
      next if app.root.to_s == root.to_s

      config.paths['db/migrate'].expanded.each do |path|
        app.config.paths['db/migrate'].push(path)
      end
    end
  end
end
