require 'spec_helper'

describe Coupons::Resolver do
  let!(:ruby_category) { Category.create!(name: 'Ruby') }
  let!(:js_category) { Category.create!(name: 'JavaScript') }
  let!(:all_about_ruby) { ruby_category.products.create!(name: 'All about Ruby', price: 29) }
  let!(:all_about_rails) { ruby_category.products.create!(name: 'All about Rails', price: 29) }
  let!(:all_about_nodejs) { js_category.products.create!(name: 'All about Node.js', price: 29) }
  let(:coupon_maker) { Object.new.extend(Coupons::Helpers) }

  before do
    Coupons.configuration.resolvers = [CategoryResolver.new]
  end

  it 'applies discount to category' do
    coupon = create_coupon(type: 'amount', amount: 1, attachments: {category: ruby_category})
    options = coupon_maker.apply(coupon.code, amount: all_about_rails.price, category: ruby_category)

    expect(options[:discount]).to eq(10)
    expect(options[:total]).to eq(19)
  end

  it 'skips discount for different category' do
    coupon = create_coupon(type: 'amount', amount: 1, attachments: {category: ruby_category})
    options = coupon_maker.apply(coupon.code, amount: all_about_rails.price, category: js_category)

    expect(options[:discount]).to eq(1)
    expect(options[:total]).to eq(28)
  end
end
