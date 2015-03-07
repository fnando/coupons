module Coupons
  module Finders
    LargerDiscount = proc do |code, options = {}|
      coupons = Models::Coupon.where(code: code).all.select(&:redeemable?)

      coupons.max do |a, b|
        a = a.apply(options)
        b = b.apply(options)

        a[:discount] <=> b[:discount]
      end
    end
  end
end
