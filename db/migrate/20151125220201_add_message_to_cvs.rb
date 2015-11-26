class AddMessageToCvs < ActiveRecord::Migration
  def change
    add_column :cvs, :message, :text
  end
end
