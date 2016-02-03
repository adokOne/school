class AddActiveToClickPrices < ActiveRecord::Migration
  def change
    add_column :click_prices, :active, :boolean
  end
end
