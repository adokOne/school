class CreatePartner < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name, null:false,default:""
      t.boolean :active, null:false, default: true
      t.timestamps
    end
    add_index(:partners, :active)
    add_attachment :partners, :logo
  end
end
