class AddHeadingToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :heading, :string
  end
end
