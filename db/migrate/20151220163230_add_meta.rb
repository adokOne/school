class AddMeta < ActiveRecord::Migration
  def change
    add_column :pages, :meta_is_generated, :boolean, default: true
    add_column :categories, :meta_is_generated, :boolean, default: true

    add_column :categories, :meta_desc_ru, :text
    add_column :categories, :meta_desc_uk, :text
    add_column :categories, :meta_desc_en, :text

    add_column :categories, :meta_keys_ru, :text
    add_column :categories, :meta_keys_uk, :text
    add_column :categories, :meta_keys_en, :text

    add_column :categories, :meta_title_ru, :string
    add_column :categories, :meta_title_uk, :string
    add_column :categories, :meta_title_en, :string


    add_column :pages, :meta_desc, :text
    add_column :pages, :meta_keys, :text
    add_column :pages, :meta_title, :string

  end
end
