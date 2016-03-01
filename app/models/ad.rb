class Ad < ActiveRecord::Base
  has_attached_file :image,
                    styles: { medium: "214x210#",thumb: "100x100#" },
                    default_url: "/img/school-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]




  def image_data=(base_64)

    content_type = base_64.match(/data:(.*);base64,/)[1]
    image_data = base_64.gsub(/data:.*;base64,/,"")

    StringIO.open(Base64.strict_decode64(image_data)) do |data|
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "temp#{DateTime.now.to_i}.#{content_type.split("/").last}"
      data.content_type = content_type
      self.image = data
    end
  end


end
