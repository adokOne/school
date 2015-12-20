class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :page_id
      t.integer :rating
      t.string :email
      t.string :name
      t.text :comment
      t.boolean :moderated, default:false
    end
  end
end
