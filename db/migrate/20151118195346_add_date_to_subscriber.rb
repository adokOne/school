class AddDateToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :date, :string
  end
end
