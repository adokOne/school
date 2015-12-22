class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :has_vip_status, :boolean, default: false
    add_column :products, :has_category_top, :boolean, default: false
    add_column :products, :has_region_top, :boolean, default: false
    add_column :products, :has_main_top, :boolean, default: false
    add_column :products, :has_adwords_stat, :boolean, default: false
    add_column :products, :period_of_service, :integer, default: 0
    add_column :orders, :start_date, :date
  end
end
