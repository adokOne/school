class AddTnxIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :tnx_id, :string, null:false
    add_index :transactions, :tnx_id, unique: true
  end
end
