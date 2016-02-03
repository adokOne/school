class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string :title, null:false
      t.string :category, null:false
      t.text :anons, null:false
      t.text :desc, null:false
      t.string :site

      t.timestamps null: false
    end
  end
end
