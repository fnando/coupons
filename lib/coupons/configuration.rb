module Coupons
  class Configuration
    # Set the list of resolvers.
    attr_accessor :resolvers

    # Set the token generator.
    attr_accessor :generator

    # Set the authorizer.
    attr_accessor :authorizer

    # Set the coupon finder strategy.
    attr_accessor :finder

    def initialize
      @resolvers = [Resolver.new]
      @generator = Generator.new
      @finder = Finders::FirstAvailable
      @authorizer = proc do |controller|
        if Rails.env.production?
          controller.render(
            text: 'Coupouns: not enabled in production environments',
            status: 403
          )
        end
      end
    end
  end
end
