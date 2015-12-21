class AddAdminIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :admin_id, :integer
  end
end
