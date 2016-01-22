class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :key ,default: ""
      t.string :value,default: ""
      t.timestamps
    end
  end
end
