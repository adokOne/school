class AddDateStartToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :date_start, :date
  end
end
