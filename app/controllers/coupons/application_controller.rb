class Coupons::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Coupons::Models
  helper Coupons::ApplicationHelper

  before_action :authorize

  private

  def authorize
    Coupons.configuration.authorizer.call(self)
  end
end
