class AddCityIdAndCountryIdToPages < ActiveRecord::Migration
  def change
    add_column :pages, :city_id, :integer
    add_column :pages, :country_id, :integer
  end
end
