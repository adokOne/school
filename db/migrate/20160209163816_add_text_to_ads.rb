class AddTextToAds < ActiveRecord::Migration
  def change
    add_column :ads, :text, :text
  end
end
