require 'spec_helper'

describe 'Authorization' do
  before do
    Coupons.configuration.authorizer = proc do |controller|
      controller.authenticate_or_request_with_http_basic do |user, pass|
        user == 'USER' && pass == 'PASS'
      end
    end
  end

  it 'requests authentication' do
    get '/coupons'
    expect(response.code).to eq('401')
  end

  it 'accepts credentials' do
    get '/coupons', {}, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('USER', 'PASS')
    expect(response.code).to eq('200')
  end

  it 'rejects invalid credentials' do
    get '/coupons', {}, 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('USER', 'INVALID')
    expect(response.code).to eq('401')
  end

  it 'disables access to production environments by default' do
    Coupons.configuration = Coupons::Configuration.new
    allow(Rails.env).to receive(:production?).and_return(true)

    get '/coupons'
    expect(response.code).to eq('403')
    expect(response.body).to eq('Coupouns: not enabled in production environments')
  end
end
