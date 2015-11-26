class Product < ActiveRecord::Base

  validates :name, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :active, inclusion:{ in: [true,false] }

  has_attached_file :logo,
                    styles: { medium: "214x210#",thumb: "100x100#" },
                    default_url: "/img/product-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  scope :active, -> { where(active: true) }

end
