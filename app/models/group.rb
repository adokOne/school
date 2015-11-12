class Group < ActiveRecord::Base
  ALLWOED_TYPES = [
    "school",
    "club"
  ]
  DEFAULT_TYPE = "school"
  CLUB_TYPE ="club"
  SCHOOL_TYPE = "school"

  validates :name,:group_type, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :group_type,    inclusion:{ in: ALLWOED_TYPES }
  validates :active, inclusion:{ in: [true,false] }

  belongs_to :course


  scope :for_school, -> { where(group_type: SCHOOL_TYPE) }
  scope :for_club, -> { where(group_type: CLUB_TYPE) }
  scope :active, -> { where(active: true) }

  delegate :name, to: :course, prefix: true, allow_nil: true

end
