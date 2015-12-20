class City < ActiveRecord::Base
  include Localizable
  include Geolizable
  #Relations
  belongs_to :country
  belongs_to :continent
  has_many :airports, dependent: :restrict_with_exception
  #End Relations
  #Validates
  validates :code,:country_id, presence: true
  validates :code,        length: { in: 3..3 },format: {with:/\A^[^0-9`!@#\$%\^&*+=]+\z/i}
  #End validates

  has_attached_file :logo, styles: { medium: "311x278>",thumb: "155x138>" }, default_url: "/img/city-missing.png",path:":rails_root/public/system/:class/:id/:style.png",url:"/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  default_scope { order("name_#{I18n.locale}") }

  def to_item
    {
      name:self.name,
      code:self.code,
      country_name:self.country.name,
      tz_offset: Time.now.in_time_zone(self.time_zone).utc_offset
    }
  end
  def to_search
    to_item.merge({airports:airports.map(&:to_search).compact})
  end

  def nearest_cities limit = 4
    Geo.nearest(self.lat,self.lng,"city",limit,5)
  end

  def link
    "/tag/#{self.seo_name}"
  end

  def anons
    read_attribute("anons_#{I18n.locale}")
  end
end
