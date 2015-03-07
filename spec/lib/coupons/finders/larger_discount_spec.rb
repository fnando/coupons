require 'spec_helper'

describe Coupons::Finders::SmallerDiscount do
  before do
    # Create a non-redeemable coupon
    coupon = create_coupon(code: 'OFF', amount: 50, type: 'amount', redemption_limit: 1)
    coupon.redemptions.create!

    # Create valid coupons
    @coupon_1 = create_coupon(code: 'OFF', amount: 200, type: 'amount')     # [1]
    @coupon_2 = create_coupon(code: 'OFF', amount: 100, type: 'amount')     # [2]
    @coupon_3 = create_coupon(code: 'OFF', amount: 50, type: 'percentage')  # [3]
  end

  # cart amount: 500
  # [1] discount=200 total=300
  # [2] discount=100 total=400
  # [3] discount=250 total=250
  # expected: [3]
  it 'returns larger discount for $500' do
    coupon = Coupons::Finders::LargerDiscount.call('OFF', amount: 500)
    expect(coupon).to eq(@coupon_3)
  end
end
