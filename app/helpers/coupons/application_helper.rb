module Coupons::ApplicationHelper
  def coupon_discount(coupon)
    t("#{coupon.type}_html", scope: 'coupons.off', amount: coupon.amount)
  end

  def coupon_description(coupon)
    classes = ['ellipsis']

    if coupon.description?
      description = coupon.description
    else
      classes << 'mute'
      description = t('coupons.coupon.no_description')
    end

    content_tag :span, description, class: classes.join(' '), title: description
  end

  def redeemed(coupon)
    limit = t('coupons.limit_html', count: coupon.redemption_limit)
    t('coupons.redeemed_html', count: coupon.redemptions_count, limit: limit)
  end

  def expiration(coupon)
    if coupon.valid_until?
      l(coupon.valid_until, format: :coupon)
    else
      content_tag :span, t('coupons.coupon.dont_expire'), class: 'mute'
    end
  end
end
