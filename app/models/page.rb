class Page < ActiveRecord::Base
  before_validation :generate_seo
  self.per_page = 1
  belongs_to :category
  has_paper_trail on: [:update, :destroy]

  has_attached_file :logo,
                    styles: { home: "760x270#",thumb: "100x100#", big: "800x300#" },
                    default_url: "/img/page-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.:extension",
                    url:         "/system/:class/:id/:style.:extension"

  validates_attachment_content_type :logo, :content_type => /\Aimage/

  delegate :title, to: :category, prefix: true, allow_nil: true
  delegate :seo_name, to: :category, prefix: true, allow_nil: true

  scope :published, -> { }
  scope :by_rating, -> { order('created_at DESC') }

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
