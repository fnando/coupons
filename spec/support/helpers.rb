module Helpers
  delegate :t, to: I18n
  include Rails.application.routes.url_helpers

  def create_coupon(attrs = {})
    Coupons::Models::Coupon.create(attrs)
  end

  def label(attribute)
    t(attribute, scope: 'coupons.labels')
  end

  def notice(scope)
    t("coupons.flash.#{scope}.notice")
  end

  def form_error
    t('coupons.form_error_description')
  end
end
