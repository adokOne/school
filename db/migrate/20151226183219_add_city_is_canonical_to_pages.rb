class AddCityIsCanonicalToPages < ActiveRecord::Migration
  def change
    add_column :pages, :city_is_canonical, :boolean, default: false
  end
end
