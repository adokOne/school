class AddPhoneToPage < ActiveRecord::Migration
  def change
    add_column :pages, :phone, :string
    add_column :pages, :site, :string
    add_column :pages, :email, :string
  end
end
