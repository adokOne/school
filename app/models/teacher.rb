class Teacher < ActiveRecord::Base


  has_attached_file :logo,
                    styles: { medium: "350x350#",thumb: "100x100#" },
                    default_url: "/img/teacher-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  validates :name,:desc, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}

  validates :is_in_school, inclusion:{ in: [true,false] }
  validates :is_in_club, inclusion:{ in: [true,false] }


  scope :for_school, -> { where(is_in_school: true) }
  scope :for_club, -> { where(is_in_club: true) }

end
