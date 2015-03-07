require 'spec_helper'

describe 'Apply discount' do
  let(:coupon) { create_coupon(amount: 15, type: 'amount') }

  it 'applies discount' do
    get '/coupons/apply', coupon: coupon.code, amount: '100.0'

    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')

    payload = JSON.load(response.body)
    expect(payload).to include('amount' => 100.0)
    expect(payload).to include('discount' => 15.0)
    expect(payload).to include('total' => 85.0)
  end

  it 'returns response for invalid coupon' do
    get '/coupons/apply', coupon: 'invalid', amount: '100.0'

    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')

    payload = JSON.load(response.body)
    expect(payload).to include('amount' => 100.0)
    expect(payload).to include('discount' => 0.0)
    expect(payload).to include('total' => 100.0)
  end

  it 'returns response for missing amount' do
    get '/coupons/apply', coupon: coupon.code

    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')

    payload = JSON.load(response.body)
    expect(payload).to include('amount' => 0.0)
    expect(payload).to include('discount' => 15.0)
    expect(payload).to include('total' => 0.0)
  end

  it 'returns response for invalid amount' do
    get '/coupons/apply', coupon: coupon.code, amount: 'invalid'

    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')

    payload = JSON.load(response.body)
    expect(payload).to include('amount' => 0.0)
    expect(payload).to include('discount' => 15.0)
    expect(payload).to include('total' => 0.0)
  end
end
