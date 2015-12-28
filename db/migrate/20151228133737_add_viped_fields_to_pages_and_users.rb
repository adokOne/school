class AddVipedFieldsToPagesAndUsers < ActiveRecord::Migration
  def change

    add_column :pages,:is_vip_db, :boolean, default: false
    add_column :pages,:has_main_top_db, :boolean, default: false
    add_column :pages,:has_city_top_db, :boolean, default: false
    add_column :pages,:has_category_top_db, :boolean, default: false





    add_column :pages,:is_vip_db_date, :date
    add_column :pages,:has_main_top_db_date, :date
    add_column :pages,:has_city_top_db_date, :date
    add_column :pages,:has_category_top_db_date, :date









    add_column :users,:is_vip_db, :boolean, default: false
    add_column :users,:is_vip_db_date, :date


  end
end
