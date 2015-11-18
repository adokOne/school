class AddLevelToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :level, :string
  end
end
