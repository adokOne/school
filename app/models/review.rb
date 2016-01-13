class Review < ActiveRecord::Base

  validates :name,:email,:page_id,:comment presence: true
  validates :name,     length: { in: 3..50 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :email,    length: { in: 6..50 }, uniqueness: true,format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

  belongs_to :page
  scope :moderated, -> { where(moderated: true) }
  scope :not_active, -> { where(moderated: false) }
end
