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



  before_save :process



  def process
    if self.changes["status"].present? && self.changes["status"].last == STATUS_SUCCESS
      self.start_date = Date.today
    end
  end
end
