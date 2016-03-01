class Partner < ActiveRecord::Base


  has_attached_file :logo,
                    styles: { medium: "300x185#",thumb: "100x100#" },
                    default_url: "/img/partner-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  validates :name, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}

  validates :active, inclusion:{ in: [true,false] }



  scope :active, -> { where(active: true) }

  def image_data=(base_64)

    content_type = base_64.match(/data:(.*);base64,/)[1]
    image_data = base_64.gsub(/data:.*;base64,/,"")

    StringIO.open(Base64.strict_decode64(image_data)) do |data|
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "temp#{DateTime.now.to_i}.#{content_type.split("/").last}"
      data.content_type = content_type
      self.logo = data
    end
  end

end
