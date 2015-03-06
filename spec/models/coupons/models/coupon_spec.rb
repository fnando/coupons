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

  it 'requires valid expires on' do
    coupon = create_coupon(expires_on: 'invalid')
    expect(coupon.errors[:expires_on]).not_to be_empty
  end

  it 'accepts valid expires on' do
    coupon = create_coupon(expires_on: Date.current)
    expect(coupon.errors[:expires_on]).to be_empty

    coupon = create_coupon(expires_on: DateTime.current)
    expect(coupon.errors[:expires_on]).to be_empty

    coupon = create_coupon(expires_on: Time.current)
    expect(coupon.errors[:expires_on]).to be_empty

    Time.zone = 'UTC'
    coupon = create_coupon(expires_on: Time.zone.now)
    expect(coupon.errors[:expires_on]).to be_empty
  end

  it 'rejects expires on' do
    coupon = create_coupon(expires_on: 1.day.ago)
    expect(coupon.errors[:expires_on]).not_to be_empty
  end

  it 'requires valid range for percentage based coupons' do
    coupon = create_coupon(amount: -1, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty

    coupon = create_coupon(amount: 101, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty

    coupon = create_coupon(amount: 10.5, type: 'percentage')
    expect(coupon.errors[:amount]).not_to be_empty
  end

  it 'accepts amount for percentage based coupons' do
    coupon = create_coupon(amount: 0, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty

    coupon = create_coupon(amount: 100, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty

    coupon = create_coupon(amount: 50, type: 'percentage')
    expect(coupon.errors[:amount]).to be_empty
  end

  it 'requires amount to be a positive number for amount based coupons' do
    coupon = create_coupon(amount: -1, type: 'amount')
    expect(coupon.errors[:amount]).not_to be_empty
  end

  it 'accepts non-zero amount for amount based coupons' do
    coupon = create_coupon(amount: 1000, type: 'amount')
    expect(coupon.errors[:amount]).to be_empty
  end

  it 'requires non-zero redemption limit' do
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
    coupon = create_coupon(amount: 100, type: 'amount')
    Coupons::Models::Coupon.update_all expires_on: 3.days.ago
    coupon.reload

    expect(coupon.reload).not_to be_redeemable
  end

  it 'is not redeemable when have no available redemptions' do
    coupon = create_coupon(amount: 100, type: 'amount')
    coupon.redemptions.create!

    expect(coupon.reload).not_to be_redeemable
  end

  describe 'serialization' do
    let!(:category) { Category.create!(name: 'Books') }
    let!(:product) { category.products.create!(name: 'All about Rails', price: 29) }

    it 'saves attachments' do
      coupon = create_coupon(
        amount: 10,
        type: 'amount',
        attachments: {category: category}
      )

      expect(coupon.reload.attachments[:category]).to eq(category)
    end
  end
end
