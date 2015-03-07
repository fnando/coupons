require 'spec_helper'

describe Coupons::Models::CouponRedemption do
  it 'updates redemption count' do
    coupon = create_coupon(amount: 100, type: 'amount')
    coupon.redemptions.create!

    expect(coupon.reload.redemptions_count).to eq(1)
  end
end
