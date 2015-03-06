require 'spec_helper'

describe Coupons::Models::Coupon do
  it 'requires code' do
    coupon = create_coupon
    coupon.code = nil
    coupon.valid?

    expect(coupon.errors[:code]).not_to be_empty
  end

  it 'requires type' do
    coupon = create_coupon
    expect(coupon.errors[:type]).not_to be_empty
  end

  it 'requires valid type' do
    coupon = create_coupon(type: 'invalid')
    expect(coupon.errors[:type]).not_to be_empty
  end

  it 'requires valid range for percentage based coupons' do
    coupon = create_coupon(amount: 0, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty

    coupon = create_coupon(amount: 101, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty

    coupon = create_coupon(amount: 10.5, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty
  end

  it 'accepts amount for percentage based coupons' do
    coupon = create_coupon(amount: 1, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty

    coupon = create_coupon(amount: 100, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty

    coupon = create_coupon(amount: 50, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty
  end

  it 'requires amount to be greater than zero for amount based coupons' do
    coupon = create_coupon(amount: 0, type: 'amount')
    expect(coupon.errors[:amount]).not_to be_empty
  end

  it 'accepts amount greater than zero for amount based coupons' do
    coupon = create_coupon(amount: 1000, type: 'amount')
    expect(coupon.errors[:amount]).to be_empty
  end

  it 'requires positive redemption limit' do
    coupon = create_coupon(redemption_limit: -1)
    expect(coupon.errors[:redemption_limit]).not_to be_empty

    coupon = create_coupon(redemption_limit: 0)
    expect(coupon.errors[:redemption_limit]).to be_empty

    coupon = create_coupon(redemption_limit: 100)
    expect(coupon.errors[:redemption_limit]).to be_empty
  end

  it 'generates default coupon code' do
    coupon = create_coupon
    expect(coupon.code).to match(/^[A-Z0-9]{6}$/)
  end

  it 'is redeemable when not expired' do
    coupon = create_coupon(amount: 100, type: 'amount', expires_on: 3.days.from_now)
    expect(coupon.reload).to be_redeemable
  end

  it 'is redeemable when have available redemptions' do
    coupon = create_coupon(amount: 100, type: 'amount')
    expect(coupon.reload).to be_redeemable
  end

  it 'is not redeemable when is expired' do
    coupon = create_coupon(amount: 100, type: 'amount', expires_on: 3.days.ago)
    expect(coupon.reload).not_to be_redeemable
  end

  it 'is not redeemable when have no available redemptions' do
    coupon = create_coupon(amount: 100, type: 'amount')
    coupon.redemptions.create!

    expect(coupon.reload).not_to be_redeemable
  end
end
