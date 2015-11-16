class AddFirstDescLineAndSecondDescLineToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :first_desc_line, :string, default:""
    add_column :partners, :second_desc_line, :string, default:""
  end
end
