module Coupons
  # Define helpers for creating, applying and redeeming coupon codes.s
  # Create an object that extends from `Coupons::Helpers`, like the following:
  #
  #     Coupon = Object.new.extend(Coupons:Helpers)
  #     coupon = Coupon.create(amount: 10, type: 'percentage', redemption_limit: 100)
  #     #=> <Coupons::Models::Coupon instance>
  #
  #     # Apply the coupon code we created above to $42.
  #     Coupon.apply(coupon.code, amount: 42)
  #     #=> {amount: 42, discount: 10, total: 32}
  #
  #    # It creates a redemption entry for this coupon.
  #    Coupon.redeem(coupon.code, amount: 42)
  #    #=> {amount: 42, discount: 10, total: 32}
  #
  module Helpers
    # Redeem coupon code.
    # The `options` must include an amount.
    # If the coupon is still good, it creates a
    # `Coupons::Models::CouponRedemption` record, updating the hash with the
    # discount value, total value with discount applied.
    # It returns discount as `0` for invalid coupons.
    #
    #     redeem('ABC123', amount: 100)
    #     #=> {amount: 100, discount: 30, total: 70}
    #
    def redeem(code, options)
      options[:discount] = 0
      options[:total] = options[:amount]

      coupon = find(code, options)
      return options unless coupon

      coupon.redemptions.create!(options.slice(:user_id, :order_id))
      coupon.apply(options)
    end

    # Apply coupon code.
    # If the coupon is still good, returns a hash containing the discount value,
    # and total value with discount applied. It doesn't redeem coupon.
    # It returns discount as `0` for invalid coupons.
    #
    #     apply('ABC123', amount: 100)
    #     #=> {amount: 100, discount: 30, total: 70}
    #
    def apply(code, options)
      options[:discount] = 0
      options[:total] = options[:amount]

      coupon = find(code, options)
      return options unless coupon

      coupon.apply(options)
    end

    # Create a new coupon code.
    def create(options)
      ::Coupons::Models::Coupon.create!(options)
    end

    # Find a valid coupon by its code.
    # It takes starting/ending date, and redemption count in consideration.
    def find(code, options)
      Coupons.configuration.finder.call(code, options)
    end
  end
end
