class ChangePagesActive < ActiveRecord::Migration
  def change
    change_column :pages, :active, :boolean, default: false
  end
end
