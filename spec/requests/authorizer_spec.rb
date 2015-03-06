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
end
