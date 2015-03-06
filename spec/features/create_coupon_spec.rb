require 'spec_helper'

feature 'Create coupon' do
  scenario 'with valid data' do
    visit '/coupons'
    within('.main-header') do
      click_on t('coupons.new_coupon_button')
    end

    fill_in label('coupon.description'), with: 'DESC'
    fill_in label('coupon.redemption_limit'), with: '1'
    select t('coupons.coupon.type.amount'), from: label('coupon.type')
    fill_in label('coupon.amount'), with: '10'
    click_button t('coupons.coupon.buttons.create')

    expect(current_path).to eq('/coupons')
    expect(all('.coupon').size).to eq(1)
    expect(page).to have_text(notice('coupons.create'))
    expect(page).to have_text('DESC')
  end

  scenario 'with invalid data' do
    visit '/coupons'
    within('.main-header') do
      click_on t('coupons.new_coupon_button')
    end

    click_button t('coupons.coupon.buttons.create')

    expect(current_path).to eq('/coupons')
    expect(all('.coupon')).to be_empty
    expect(page).to have_text(form_error)
  end
end
