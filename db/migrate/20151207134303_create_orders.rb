class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :product_id
      t.integer :user_id
      t.integer :page_id
      t.integer :transaction_id
      t.float :amount
      t.string :currency
      t.timestamps
    end
  end
end
