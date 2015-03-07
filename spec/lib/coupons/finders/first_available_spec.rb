require 'spec_helper'

describe Coupons::Finders::FirstAvailable do
  before do
    # Create a non-redeemable coupon
    coupon = create_coupon(code: 'OFF', amount: 50, type: 'amount', redemption_limit: 1)
    coupon.redemptions.create!

    # Create valid coupons
    create_coupon(code: 'OFF', amount: 100, type: 'amount')
    create_coupon(code: 'OFF', amount: 200, type: 'amount')
    create_coupon(code: 'OFF', amount: 50, type: 'percentage')
  end

  it 'returns first available coupon' do
    coupon = Coupons::Finders::FirstAvailable.call('OFF')
    expect(coupon.amount).to eq(100)
  end
end
