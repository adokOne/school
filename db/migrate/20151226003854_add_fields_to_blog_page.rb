class AddFieldsToBlogPage < ActiveRecord::Migration
  def change
    add_column :blog_pages, :old_id ,:integer
    add_column :blog_pages, :admin_id ,:integer
    add_column :blog_pages, :admin_update_id ,:integer
    add_column :blog_pages, :slug ,:string
    add_column :pages, :admin_update_id ,:integer
  end
end
