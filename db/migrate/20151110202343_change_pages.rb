class ChangePages < ActiveRecord::Migration
  def change
    change_column :pages, :author,  :string
  end
end
