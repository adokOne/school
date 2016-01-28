class ChangeLocales < ActiveRecord::Migration
  def change
    add_column :translations, :value_en, :text, limit: 4294967295
    add_column :translations, :value_ru, :text, limit: 4294967295
    add_column :translations, :value_uk, :text, limit: 4294967295
    change_column :translations, :value, :text, limit: 4294967295
  end
end
