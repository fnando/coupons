require './lib/coupons/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.1'
  spec.name          = 'coupons'
  spec.version       = Coupons::VERSION
  spec.authors       = ['Nando Vieira']
  spec.email         = ['fnando.vieira@gmail.com']
  spec.summary       = 'A simple discount coupon generator for Rails.'
  spec.description   = spec.summary
  spec.homepage      = 'http://rubygems.org/gems/coupons'
  spec.license       = 'MIT'

  spec.files         = Dir[
    '{app,config,db,lib,spec}/**/*',
    '{Gemfile,Rakefile}',
    '*.{txt,md,gemspec}'
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 4.2.0', '< 5.0.0'
  spec.add_dependency 'autoprefixer-rails'
  spec.add_dependency 'sass-rails'
  spec.add_dependency 'page_meta'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'paginate'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'pry-meta'
  spec.add_development_dependency 'mysql2', '~> 0.3.13'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'globalid'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'poltergeist'
end
