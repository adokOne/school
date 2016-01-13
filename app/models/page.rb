class Page < ActiveRecord::Base
  before_validation :generate_seo

  belongs_to :category
  has_paper_trail on: [:update, :destroy]

  has_attached_file :logo,
                    styles: { medium: "470x325#",thumb: "100x100#", big: "710x475#" },
                    default_url: "/img/page-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  delegate :title, to: :category, prefix: true, allow_nil: true
  delegate :seo_name, to: :category, prefix: true, allow_nil: true

  scope :active, -> { where(active: true) }

  def seos
    [self.category.seos,self.seo_name].flatten
  end

  def self.find_by_seo seo
    item = Page.where(seo_name: seo.last).first
    return false unless item
    seo.each do |s|
      return false unless item.seos.include?(s)
    end
    item
  end

  def generate_seo
    self.seo_name = self.title.russian_translit if self.respond_to?(:seo_name) && !self.title.nil? && self.seo_name.nil?
  end

end
