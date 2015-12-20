class AddFullDescToProducts < ActiveRecord::Migration
  def change
    rename_column :products, :name, :name_ru
    rename_column :products, :desc, :desc_ru
    add_column :products, :name_uk, :string
    add_column :products, :name_en, :string

    add_column :products, :desc_uk, :text, limit: 200000
    add_column :products, :desc_en, :text, limit: 200000

    change_column :products, :desc_ru, :text, limit: 200000


    add_column :products, :anons_en, :text
    add_column :products, :anons_ru, :text
    add_column :products, :anons_uk, :text


  end
end
