Rails.application.routes.draw do
  mount Coupons::Engine => '/', as: 'coupons_engine'
end
