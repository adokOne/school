class AddMainTypeToPortfolios < ActiveRecord::Migration
  def change
    add_column :portfolios, :main_type, :string
  end
end
