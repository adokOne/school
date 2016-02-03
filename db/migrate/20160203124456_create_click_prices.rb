class CreateClickPrices < ActiveRecord::Migration
  def change
    create_table :click_prices do |t|
      t.string :plus
      t.string :desc
      t.string :title
      t.text :bullet
      t.integer :price

      t.timestamps null: false
    end
  end
end
