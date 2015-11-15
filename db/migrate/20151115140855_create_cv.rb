class CreateCv < ActiveRecord::Migration
  def change
    create_table :cvs do |t|
      t.string :name, default: ""
      t.string :email, default: ""
      t.string :phone, default: ""
    end
  end
end
