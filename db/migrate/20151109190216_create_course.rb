class CreateCourse < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name, null:false,default:""
      t.string :type, null:false
      t.boolean :active, null:false, default: true
      t.timestamps
    end
    add_attachment :courses, :logo
    add_index(:courses, :type)
  end
end
