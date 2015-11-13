class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :date, null:false,default:""
      t.string :time, null:false,default:""
      t.integer :course_id, null:false,default:0
      t.boolean :active, null:false, default: true
      t.timestamps
    end
    add_index(:lessons, :course_id)
  end
end
