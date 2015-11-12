class CreateGroup < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null:false,default:""
      t.string :group_type, null:false
      t.boolean :active, null:false, default: true
      t.timestamps
    end
    add_index(:groups, :group_type)
  end
end
