class AddShowInTopAndHasSaleToProducts < ActiveRecord::Migration
  def change
    add_column :products, :show_in_top, :boolean, default: false
    add_column :products, :has_sale, :boolean, default: false
    add_column :products, :has_second_price, :boolean, default: false
    add_column :products, :is_one_time, :boolean, default: false
    add_column :products, :price, :float, default: 0.0
    add_column :products, :second_price, :float, default: 0.0
    add_column :products, :sale_price, :float, default: 0.0
  end
end
