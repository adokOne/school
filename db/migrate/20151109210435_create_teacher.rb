class CreateTeacher < ActiveRecord::Migration

  def change
    create_table :teachers do |t|
      t.string :name, null:false,default:""
      t.text :desc, null:false
      t.boolean :is_in_school, null:false, default: true
      t.boolean :is_in_club, null:false, default: true
      t.timestamps
    end
    add_index(:teachers, :is_in_school)
    add_index(:teachers, :is_in_club)
    add_attachment :teachers, :logo
  end

end
