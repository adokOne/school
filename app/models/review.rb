class Review < ActiveRecord::Base
  belongs_to :page
  scope :moderated, -> { where(moderated: true) }
  scope :not_active, -> { where(moderated: false) }
end
