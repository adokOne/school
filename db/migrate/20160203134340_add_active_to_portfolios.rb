class AddActiveToPortfolios < ActiveRecord::Migration
  def change
    add_column :portfolios, :active, :boolean
  end
end
