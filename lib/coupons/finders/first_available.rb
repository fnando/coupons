module Coupons
  module Finders
    FirstAvailable = proc do |code, options = {}|
      coupons = Models::Coupon.where(code: code).all
      coupons.find(&:redeemable?)
    end
  end
end
