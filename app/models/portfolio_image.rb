class PortfolioImage < ActiveRecord::Base
  belongs_to :portfolio
  has_attached_file :logo,
                    styles: { medium: "",thumb: "" },
                    default_url: "/img/photo-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png",
                    convert_options: {
                      large: "-gravity north -thumbnail 400x270^ -extent 400x270" ,
                      medium: "-gravity north -thumbnail 400x270^ -extent 400x270",
                      thumb: "-gravity north -thumbnail 68x48^ -extent 68x48"
                    }
  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
end
