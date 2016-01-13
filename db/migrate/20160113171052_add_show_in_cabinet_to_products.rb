class AddShowInCabinetToProducts < ActiveRecord::Migration
  def change
    add_column :products, :show_in_cabinet, :boolean,  default: false
    add_column :products, :show_on_landing, :boolean,  default: false
  end
end
