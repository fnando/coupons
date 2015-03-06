module Helpers
  def create_coupon(attrs = {})
    Coupons::Models::Coupon.create(attrs)
  end
end
