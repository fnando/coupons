require 'spec_helper'

feature 'Duplicate coupon' do
  scenario 'with valid data' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.duplicate')

    expect(current_path).to eq("/coupons/#{coupon.id}/duplicate")

    click_button t('coupons.coupon.buttons.create')

    expect(current_path).to eq('/coupons')
    expect(all('.coupon').size).to eq(2)
    expect(page).to have_text(notice('coupons.create'))
  end

  scenario 'with invalid data' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.duplicate')
    fill_in label('coupon.code'), with: ''
    click_button t('coupons.coupon.buttons.create')

    expect(current_path).to eq('/coupons')
    expect(all('.coupon')).to be_empty
    expect(page).to have_text(form_error)
  end
end
