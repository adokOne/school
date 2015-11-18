class AddFbLinkToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :fb_link, :string
  end
end
