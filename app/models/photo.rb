class Photo < ActiveRecord::Base


  has_attached_file :logo,
                    styles: { medium: "260x200#",thumb: "100x100#" },
                    default_url: "/img/photo-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"
  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  validates :name, presence: true
  validates :name, length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}


end
