class AddTitleAndIsMainToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :title, :string,default: ""
    add_column :addresses, :is_main, :boolean, default: false
  end
end
