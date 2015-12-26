class AddFocuskwToPages < ActiveRecord::Migration
  def change
    add_column :pages, :focuskw, :string
  end
end
