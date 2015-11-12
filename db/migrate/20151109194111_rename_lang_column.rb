class RenameLangColumn < ActiveRecord::Migration
  def change
    rename_column :b1_admin_modules, :name_ru, :name_uk
    rename_column :b1_admin_permissions, :desc_ru, :desc_uk
    rename_column :b1_admin_roles, :desc_ru, :desc_uk
  end
end
