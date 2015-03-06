module Coupons
  # A resolver allows you to create more complex coupon logic like:
  #
  # - Coupon for a category of products
  # - Coupon for a specific product
  # - Coupon for a minimum number of items on your cart
  #
  # You're not limited to that. Unfortunately, we can't think of all the cases,
  # so the default resolver does nothing.
  #
  # When a coupon is applied to an amount, it does normally, calculating the
  # discount based on percentage or amount (whichever you defined on your coupon).
  # Then we call the resolver's resolve method.
  #
  # For this to work, you must provide one or more objects when creating the
  # coupon. These objects must use the [globalid](https://github.com/rails/globalid)
  # library.
  #
  class Resolver
    def resolve(coupon, options)
      options
    end
  end
end
