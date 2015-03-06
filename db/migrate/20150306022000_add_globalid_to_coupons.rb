class AddGlobalidToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :attachments, :text, null: false, default: '{}'
  end
end
