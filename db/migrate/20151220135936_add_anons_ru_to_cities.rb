class AddAnonsRuToCities < ActiveRecord::Migration
  def change
    add_column :cities, :anons_ru, :string
    add_column :cities, :anons_uk, :string
    add_column :cities, :anons_en, :string

    add_column :cities, :seo_text_ru, :string
    add_column :cities, :seo_text_uk, :string
    add_column :cities, :seo_text_en, :string


    add_column :categories, :seo_text_ru, :string
    add_column :categories, :seo_text_uk, :string
    add_column :categories, :seo_text_en, :string

  end
end
