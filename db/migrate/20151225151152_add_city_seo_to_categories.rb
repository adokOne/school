class AddCitySeoToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :city_seo_template_ru, :text
    add_column :categories, :city_seo_template_en, :text
    add_column :categories, :city_seo_template_uk, :text
  end
end
