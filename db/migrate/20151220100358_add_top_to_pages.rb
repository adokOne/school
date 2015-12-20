class AddTopToPages < ActiveRecord::Migration
  def change
    add_column :pages, :in_ukraine_top, :boolean, default: false
    add_column :pages, :in_state_top, :boolean, default: false
    add_column :pages, :in_category_top, :boolean, default: false
    add_column :pages, :ukraine_top_date, :date
    add_column :pages, :state_top_date, :date
    add_column :pages, :category_top_date, :date
  end
end
