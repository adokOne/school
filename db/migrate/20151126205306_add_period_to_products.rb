class AddPeriodToProducts < ActiveRecord::Migration
  def change
    add_column :products, :period, :string
  end
end
