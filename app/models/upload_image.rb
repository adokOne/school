class UploadImage < ActiveRecord::Base

  has_attached_file :file,  {
                              styles: { medium: "580x", thumb: "100x100>" },
                              default_url: "/images/:style/missing.png",
                              path: ":rails_root/public/system/:class/:id/:style.png",
                              url: "/system/:class/:id/:style.png"#,
                             # processors: [:thumbnail, :compression]
                            }

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  #after_save :compress_with_ffmpeg

  def compress_with_ffmpeg
    [:thumb, :original, :medium].each do |type|
      img_path = self.file.path(type)
      Paperclip.run("ffmpeg", " -y -i #{img_path} #{img_path}")
    end
  end

  def image_data=(base_64)

    content_type = base_64.match(/data:(.*);base64,/)[1]
    image_data = base_64.gsub(/data:.*;base64,/,"")

    StringIO.open(Base64.strict_decode64(image_data)) do |data|
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "temp#{DateTime.now.to_i}.#{content_type.split("/").last}"
      data.content_type = content_type
      self.file = data
    end
  end



end
