module Coupons
  require 'coupons/version'
  require 'coupons/engine'
  require 'coupons/configuration'
  require 'coupons/generator'
  require 'coupons/helpers'
  require 'coupons/models/coupon'
  require 'coupons/models/coupon_redemption'

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

  configure do |config|
    config.generator = Generator.new
  end
end
