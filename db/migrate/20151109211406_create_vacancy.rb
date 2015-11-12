class CreateVacancy < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :name, null:false,default:""
      t.text :desc, null:false
      t.boolean :active, null:false, default: true
      t.timestamps
    end
  end
end
