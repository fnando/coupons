class Coupons::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Coupons::Models
  helper Coupons::ApplicationHelper
end
