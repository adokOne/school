class RenameTypeColumn < ActiveRecord::Migration
  def change
    rename_column :courses, :type, :course_type
  end
end
