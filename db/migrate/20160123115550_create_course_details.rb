class CreateCourseDetails < ActiveRecord::Migration
  def change
    create_table :course_details do |t|
      t.integer :course_id
      t.text :value

      t.timestamps null: false
    end
  end
end
