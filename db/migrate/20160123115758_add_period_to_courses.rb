class AddPeriodToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :period, :string
  end
end
