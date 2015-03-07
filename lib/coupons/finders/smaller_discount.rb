module Coupons
  module Finders
    SmallerDiscount = proc do |code, options = {}|
      coupons = Models::Coupon.where(code: code).all.select(&:redeemable?)

      coupons.min do |a, b|
        a = a.apply(options)
        b = b.apply(options)

        a[:discount] <=> b[:discount]
      end
    end
  end
end
