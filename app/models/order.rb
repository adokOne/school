class Order < ActiveRecord::Base


  belongs_to :user
  belongs_to :product
  #belongs_to :transaction
  belongs_to :page
  belongs_to :admin, class_name: "B1Admin::User", foreign_key: :admin_id

  STATUS_CREATED = 0
  STATUS_SUCCESS = 1
  STATUS_PROGRESS = 2

  validates :status, inclusion:{ in: [STATUS_CREATED,STATUS_SUCCESS,STATUS_PROGRESS] }




end
