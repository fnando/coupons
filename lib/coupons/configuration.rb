module Coupons
  class Configuration
    # Set the list of resolvers.
    attr_accessor :resolvers

    # Set the token generator.
    attr_accessor :generator

    # Set the authorizer.
    attr_accessor :authorizer

    def initialize
      @resolvers = [Resolver.new]
      @generator = Generator.new
      @authorizer = proc do |controller|
        Rails.env != 'production'
      end
    end
  end
end
