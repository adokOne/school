class FixDatabaseCol < ActiveRecord::Migration
  def change
    rename_column :b1_admin_modules, :desc_ru, :name_ru
  end
end
