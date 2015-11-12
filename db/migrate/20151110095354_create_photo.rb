class CreatePhoto < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name, null:false,default:""
      t.boolean :is_in_school, null:false, default: true
      t.boolean :is_in_club, null:false, default: true
      t.timestamps
    end
    add_index(:photos, :is_in_school)
    add_index(:photos, :is_in_club)
    add_attachment :photos, :logo
  end
end
