class Ad < ActiveRecord::Base
  has_attached_file :image,
                    styles: { medium: "214x210#",thumb: "100x100#" },
                    default_url: "/img/school-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
