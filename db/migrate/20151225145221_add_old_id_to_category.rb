class AddOldIdToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :old_id, :integer
  end
end
