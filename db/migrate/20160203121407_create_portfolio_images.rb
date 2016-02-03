class CreatePortfolioImages < ActiveRecord::Migration
  def change
    create_table :portfolio_images do |t|
      t.boolean :is_main ,default: false
      t.integer :portfolio_id
      t.timestamps null: false
    end
  end
end
