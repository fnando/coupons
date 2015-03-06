module Coupons
  module Models
    class CouponRedemption < ActiveRecord::Base
      # Set table name.
      self.table_name = :coupon_redemptions

      belongs_to :coupon, counter_cache: true
    end
  end
end
