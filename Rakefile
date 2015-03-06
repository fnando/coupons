require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

require 'yaml'

desc 'Run specs against all gemfiles'
task 'spec:all' do
  YAML.load_file(File.expand_path('../.travis.yml', __FILE__))['gemfile'].each do |gemfile|
    puts "\n=> Running with Gemfile: #{gemfile}"
    puts "=> Installing dependencies"
    system "BUNDLE_GEMFILE=#{gemfile} bundle install"
    exit 1 unless $?.success?

    puts "=> Running tests"
    system "BUNDLE_GEMFILE=#{gemfile} bundle exec rspec"
    exit 1 unless $?.success?
  end
end
