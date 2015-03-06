require 'spec_helper'

feature 'Edit coupon' do
  scenario 'with valid data' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.edit')

    fill_in label('coupon.description'), with: 'UPDATED DESC'
    click_button t('coupons.coupon.buttons.edit')

    expect(current_path).to eq('/coupons')
    expect(page).to have_text(notice('coupons.update'))
    expect(page).to have_text('UPDATED DESC')
  end

  scenario 'with invalid data' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.edit')

    fill_in label('coupon.code'), with: ''
    click_button t('coupons.coupon.buttons.edit')

    expect(current_path).to eq("/coupons/#{coupon.id}")
    expect(page).to have_text(form_error)
  end
end
