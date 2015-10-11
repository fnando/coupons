module Coupons
  require 'coupons/version'
  require 'coupons/engine'
  require 'coupons/configuration'
  require 'coupons/generator'
  require 'coupons/helpers'
  require 'coupons/collection'
  require 'coupons/globalid_serializer'
  require 'coupons/resolver'
  require 'coupons/models/coupon'
  require 'coupons/models/coupon_redemption'
  require 'coupons/form_builder'
  require 'coupons/coupon_type'
  require 'coupons/finders/first_available'
  require 'coupons/finders/smaller_discount'
  require 'coupons/finders/larger_discount'

  begin
    require 'paginate'
    require 'coupons/paginate'
  rescue LoadError
  end

  require 'autoprefixer-rails'
  require 'sass-rails'

  require 'page_meta'

  class << self
    # Set the Coupons configuration.
    attr_accessor :configuration
  end

  # A convenience method for configuring Coupons.
  # It'll yield the configuration to the specified block.
  def self.configure(&block)
    yield configuration
  end

  # Initialize the default configuration object.
  self.configuration = Configuration.new

  # Inject helpers.
  extend Helpers
end
