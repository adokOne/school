class AddAdminIdAndProcessedToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :admin_id, :integer
    add_column :feedbacks, :processed, :boolean, default: false
  end
end
