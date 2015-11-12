class Course < ActiveRecord::Base
  ALLWOED_TYPES = [
    "school",
    "club"
  ]
  DEFAULT_TYPE = "school"
  CLUB_TYPE ="club"
  SCHOOL_TYPE = "school"

  validates :name,:course_type, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :course_type,    inclusion:{ in: ALLWOED_TYPES }
  validates :active, inclusion:{ in: [true,false] }

  has_attached_file :logo,
                    styles: { medium: "214x210#",thumb: "100x100#" },
                    default_url: "/img/school-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  scope :for_school, -> { where(course_type: SCHOOL_TYPE) }
  scope :for_club, -> { where(course_type: CLUB_TYPE) }
  scope :active, -> { where(active: true) }

end
