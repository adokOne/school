class AddOldIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :old_id, :integer
  end
end
