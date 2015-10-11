require 'paginate/compat'
require 'coupons/paginate_renderer'
Coupons::Models::Coupon.include Paginate::Extension
