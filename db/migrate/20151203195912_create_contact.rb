class CreateContact < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :type, null: false
      t.string :value
      t.integer :user_id, null: false
    end
    add_index :contacts, :user_id
  end
end
