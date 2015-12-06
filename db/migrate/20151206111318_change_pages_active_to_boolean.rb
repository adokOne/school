class ChangePagesActiveToBoolean < ActiveRecord::Migration
  def change
    change_column :pages, :active, :boolean, null: false ,default: false
  end
end
