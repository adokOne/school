class AddCurrencyToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :currency, :string, default: "UAH"
  end
end
