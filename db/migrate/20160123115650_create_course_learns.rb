class CreateCourseLearns < ActiveRecord::Migration
  def change
    create_table :course_learns do |t|
      t.integer :course_id
      t.text :value

      t.timestamps null: false
    end
  end
end
