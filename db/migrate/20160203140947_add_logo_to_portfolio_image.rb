class AddLogoToPortfolioImage < ActiveRecord::Migration
  def change
    add_attachment :portfolio_images, :logo
  end
end
