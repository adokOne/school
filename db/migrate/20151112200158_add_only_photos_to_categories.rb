class AddOnlyPhotosToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :only_photos, :boolean
  end
end
