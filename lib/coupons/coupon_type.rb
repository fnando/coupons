module Coupons
  class CouponType
    def self.to_select
      [
        [I18n.t('coupons.coupon.type.amount'), 'amount'],
        [I18n.t('coupons.coupon.type.percentage'), 'percentage']
      ]
    end
  end
end
