class Coupons::CouponsController < Coupons::ApplicationController
  def index
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)

    if @coupon.save
      redirect_to coupons_path,
        notice: t('coupons.flash.coupons.create.notice')
    else
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])

    if @coupon.update(coupon_params)
      redirect_to coupons_path,
        notice: t('coupons.flash.coupons.update.notice')
    else
      render :edit
    end
  end

  def remove
    @coupon = Coupon.find(params[:id])
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    @coupon.destroy!

    redirect_to coupons_path,
      notice: t('coupons.flash.coupons.destroy.notice')
  end

  def batch
    if params[:remove_action]
      batch_removal
    else
      redirect_to coupons_path,
        alert: t('coupons.flash.coupons.batch.invalid_action')
    end
  end

  private

  def batch_removal
    Coupon.where(id: params[:coupon_ids]).destroy_all

    redirect_to coupons_path,
      notice: t('coupons.flash.coupons.batch.removal.notice')
  end

  def coupon_params
    params
      .require(:coupon)
      .permit(:code, :redemption_limit, :description, :expires_on, :amount, :type)
  end
end
