class PortfolioImage < ActiveRecord::Base
  belongs_to :portfolio
  has_attached_file :logo,
                    styles: { medium: "360x240>",thumb: "68x48>" },
                    default_url: "/img/photo-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"
  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
