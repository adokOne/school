class Review < ActiveRecord::Base
  belongs_to :page
  scope :moderated, -> { where(moderated: true) }
end
