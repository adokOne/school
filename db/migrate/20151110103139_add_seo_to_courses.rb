class AddSeoToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :seo, :string, default: "", null:false
  end
end
