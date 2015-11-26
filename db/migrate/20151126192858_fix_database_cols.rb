class FixDatabaseCols < ActiveRecord::Migration
  def change
    remove_column :categories, :only_photos
    remove_column :pages, :author
    remove_column :partners, :first_desc_line
    remove_column :partners, :second_desc_line
    remove_column :photos, :is_in_school
    remove_column :photos, :is_in_club

    rename_column :b1_admin_permissions, :desc_en, :desc_ru
    rename_column :b1_admin_roles, :desc_en, :desc_ru
    rename_column :b1_admin_modules, :name_en, :desc_ru


    remove_column :b1_admin_users, :hotelier_id
    remove_column :b1_admin_users, :contract_owner_id


  end
end
