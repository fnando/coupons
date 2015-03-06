require 'spec_helper'

feature 'Remove coupon' do
  scenario 'with valid data' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.remove')
    click_on t('coupons.actions.confirm')

    expect(current_path).to eq('/coupons')
    expect(page).to have_text(notice('coupons.destroy'))
    expect(all('.coupon')).to be_empty
  end

  scenario 'when canceling' do
    coupon = create_coupon(type: 'amount', amount: 10)

    visit '/coupons'
    click_on t('coupons.actions.remove')
    click_on t('coupons.actions.cancel')

    expect(current_path).to eq("/coupons")
    expect(all('.coupon').size).to eq(1)
  end
end
