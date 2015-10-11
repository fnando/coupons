class Coupons::CouponsController < Coupons::ApplicationController
  def apply
    coupon_code = params[:coupon]
    amount = BigDecimal(params.fetch(:amount, '0.0'))
    options = Coupons
              .apply(params[:coupon], amount: amount)
              .slice(:amount, :discount, :total)
              .reduce({}) {|buffer, (key, value)| buffer.merge(key => Float(value)) }

    render json: options
  end

  def index
    paginator = Coupons.configuration.paginator
    @coupons = Coupons::Collection.new(paginator.call(Coupon.order(created_at: :desc), params[:page]))
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

  def duplicate
    existing_coupon = Coupon.find(params[:id])
    attributes = existing_coupon.attributes.symbolize_keys.slice(:description, :valid_from, :valid_until, :redemption_limit, :amount, :type)
    @coupon = Coupon.new(attributes)
    render :new
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
      .permit(:code, :redemption_limit, :description, :valid_from, :valid_until, :amount, :type)
  end
end
