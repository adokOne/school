class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.text :desc
      t.string :color
      t.boolean :active, default: false
      t.timestamps null: false
    end
    add_attachment :ads, :image
  end
end
