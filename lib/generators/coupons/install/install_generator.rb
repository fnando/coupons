class Coupons::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer
    template 'initializer.erb', 'config/initializers/coupons.rb'
  end
end
