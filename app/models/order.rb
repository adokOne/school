class Order < ActiveRecord::Base


  belongs_to :user
  belongs_to :product
  #belongs_to :transaction

  STATUS_CREATED = 0
  STATUS_SUCCESS = 1
  STATUS_FAILED  = 2
  STATUS_DEBITED = 3

  validates :status, inclusion:{ in: [STATUS_CREATED,STATUS_SUCCESS,STATUS_FAILED, STATUS_DEBITED] }

  scope :for_balance, -> { where(status: [STATUS_SUCCESS, STATUS_DEBITED  ]  ) }


end
