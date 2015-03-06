require './lib/coupons/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.0'
  spec.name          = 'coupons'
  spec.version       = Coupons::VERSION
  spec.authors       = ['Nando Vieira']
  spec.email         = ['fnando.vieira@gmail.com']
  spec.summary       = 'A simple discount coupon generator for Rails.'
  spec.description   = spec.summary
  spec.homepage      = 'http://rubygems.org/gems/coupons'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'pry-meta'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'globalid'
end
