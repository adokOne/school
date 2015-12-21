class Transaction < ActiveRecord::Base

  before_validation :set_tnx


  belongs_to :user
  belongs_to :product

  STATUS_CREATED = 0
  STATUS_SUCCESS = 1
  STATUS_FAILED  = 2
  STATUS_DEBITED = 3

  validates :status, inclusion:{ in: [STATUS_CREATED,STATUS_SUCCESS,STATUS_FAILED, STATUS_DEBITED] }

  scope :for_balance, -> { where(status: [STATUS_SUCCESS, STATUS_DEBITED  ]  ) }
  scope :payed, -> { where(status: STATUS_SUCCESS  ) }

  def set_tnx
    self.status = STATUS_CREATED if self.status.nil?
    self.tnx_id = (0...8).map { (65 + rand(26)).chr }.join
    self.description = I18n.t("uex.base_transaction_description") if read_attribute(:description).nil?
  end

  def description
    _description = read_attribute(:description)
    unless _description.present?
      _description = I18n.t("uex.base_transaction_description")
    end
    _description
  end

end
