class AddOldParentToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :old_parent, :integer
  end
end
