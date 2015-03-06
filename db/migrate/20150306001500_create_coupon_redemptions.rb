class CreateCouponRedemptions < ActiveRecord::Migration
  def change
    create_table :coupon_redemptions do |t|
      t.belongs_to :coupon, null: false
      t.string :user_id, null: true
      t.string :order_id, null: true
      t.timestamps null: false
    end
  end
end
