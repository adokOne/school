class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :payment_system
      t.float :amount
      t.integer :user_id
      t.string :description
      t.integer :product_id
    end
  end
end
