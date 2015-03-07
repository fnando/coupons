require 'spec_helper'

describe Coupons::Helpers do
  let(:maker) { Object.new.extend(Coupons::Helpers) }

  it 'extends Coupons' do
    method_list = Coupons.singleton_methods

    expect(method_list).to include(:apply)
    expect(method_list).to include(:redeem)
    expect(method_list).to include(:create)
    expect(method_list).to include(:find)
  end

  it 'creates coupon' do
    coupon = maker.create(amount: 10, type: 'amount')
    expect(coupon).to be_persisted
  end

  it 'applies percentage coupon' do
    coupon = maker.create(amount: 10, type: 'percentage')
    options = maker.apply(coupon.code, amount: 150)

    expect(options[:amount]).to eq(150)
    expect(options[:discount]).to eq(15)
    expect(options[:total]).to eq(135)
  end

  it 'applies amount coupon' do
    coupon = maker.create(amount: 10, type: 'amount')
    options = maker.apply(coupon.code, amount: 150)

    expect(options[:amount]).to eq(150)
    expect(options[:discount]).to eq(10)
    expect(options[:total]).to eq(140)
  end

  it 'redeems coupon' do
    coupon = maker.create(amount: 10, type: 'amount', redemption_limit: 2)

    expect {
      maker.redeem(coupon.code, amount: 100)
    }.to change { coupon.redemptions.count }.by(1)

    expect {
      maker.redeem(coupon.code, amount: 100)
    }.to change { coupon.reload.coupon_redemptions_count }.by(1)
  end

  it 'applies coupon' do
    coupon = maker.create(amount: 10, type: 'amount')
    options = maker.redeem(coupon.code, amount: 100)

    expect(options[:amount]).to eq(100)
    expect(options[:total]).to eq(90)
    expect(options[:discount]).to eq(10)
  end

  it 'saves user id' do
    coupon = maker.create(amount: 10, type: 'amount')
    maker.redeem(coupon.code, user_id: 1234)
    expect(coupon.redemptions.last.user_id).to eq('1234')
  end

  it 'saves order id' do
    coupon = maker.create(amount: 10, type: 'amount')
    maker.redeem(coupon.code, order_id: 1234)
    expect(coupon.redemptions.last.order_id).to eq('1234')
  end
end
