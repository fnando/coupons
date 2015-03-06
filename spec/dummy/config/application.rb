ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)

require 'rails/all'
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    config.root = Pathname.new(File.expand_path('../..', __FILE__))
    config.secret_key_base = SecureRandom.hex(100)
    config.cache_classes = true
    config.eager_load = false
    config.serve_static_files = true
    config.static_cache_control = 'public, max-age=3600'
    config.consider_all_requests_local = true
    config.action_controller.perform_caching = false
    config.action_dispatch.show_exceptions = false
    config.action_controller.allow_forgery_protection = false
    config.action_mailer.delivery_method = :test
    config.active_support.deprecation = :stderr
  end
end

Rails.application.initialize!
