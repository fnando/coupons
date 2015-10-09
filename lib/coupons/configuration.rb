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

    # Set pagination lib.
    attr_accessor :pagination_adapter

    # Set the paginator strategy.
    attr_accessor :paginator

    # Set the page size.
    attr_accessor :per_page

    def initialize
      @resolvers = [Resolver.new]
      @generator = Generator.new
      @finder = Finders::FirstAvailable
      @per_page = 50
      @pagination_adapter = if defined?(Kaminari)
                              :kaminari
                            else
                              :paginate
                            end

      @paginator =  if pagination_adapter == :kaminari
                      -> relation, page { relation.page(page).per(Coupons.configuration.per_page) }
                    else
                      -> relation, page { relation.paginate(page: page, size: Coupons.configuration.per_page) }
                    end

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
