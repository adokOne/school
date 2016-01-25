class AddMetaIsGeneratedToBlogPages < ActiveRecord::Migration
  def change
    add_column :blog_pages, :meta_is_generated, :boolean, default:true
    add_column :blog_pages, :meta_desc, :text
    add_column :blog_pages, :meta_keys, :text
    add_column :blog_pages, :meta_title, :text

  end
end
