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
end
