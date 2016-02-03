class AddFilkedsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :learn_desc, :text, limit: 429496
    add_column :courses, :detail_desc, :text, limit: 429496
  end
end
