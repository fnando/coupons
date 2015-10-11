class SetupCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.string :description, null: true
      t.date :valid_from, null: false
      t.date :valid_until, null: true
      t.integer :redemption_limit, default: 1, null: false
      t.integer :coupon_redemptions_count, default: 0, null: false
      t.integer :amount, null: false, default: 0
      t.string :type, null: false
      t.timestamps null: false

      case ActiveRecord::Base.connection.adapter_name
      when 'Mysql2'
        t.text :attachments
      else
        t.text :attachments, null: false, default: '{}'
      end
    end

    create_table :coupon_redemptions do |t|
      t.belongs_to :coupon, null: false
      t.string :user_id, null: true
      t.string :order_id, null: true
      t.timestamps null: false
    end
  end
end
