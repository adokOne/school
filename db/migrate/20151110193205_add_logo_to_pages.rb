class AddLogoToPages < ActiveRecord::Migration
  def change
    add_attachment :pages, :logo
  end
end
