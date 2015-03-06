module Coupons
  class Engine < Rails::Engine
    isolate_namespace Coupons

    initializer 'coupons.append_migrations' do |app|
      next if app.root.to_s == root.to_s

      config.paths['db/migrate'].expanded.each do |path|
        app.config.paths['db/migrate'].push(path)
      end
    end

    initializer 'coupons.assets' do |app|
      app.config.assets.precompile += %w[coupons.css coupons.js]
    end

    initializer 'coupons.locale' do |app|
      app.config.i18n.load_path += Dir[File.expand_path('../../../config/locale/**/*.yml', __FILE__)]
    end
  end
end
