class AddCreatedAtToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :created_at, :datetime
  end
end
