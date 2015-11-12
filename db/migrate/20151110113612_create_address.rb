class CreateAddress < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name, null:false,default:""
      t.string :email, null:false, default:""
      t.string :phones, null:false, default:""
      t.boolean :active, null:false, default: true
      t.timestamps
    end
    add_index(:addresses, :active)
  end
end
