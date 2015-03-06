Coupons::Engine.routes.draw do
  resources :coupons do
    get :remove, on: :member
  end

  patch '/coupons', to: 'coupons#batch'
end
