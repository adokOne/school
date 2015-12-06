class Country < ActiveRecord::Base
  include Localizable
  include Geolizable
  UKRAINE_ID = 396
  #Relations
  has_many :cities, dependent: :restrict_with_exception
  has_many :airports, dependent: :restrict_with_exception
  has_many :airlines
  belongs_to :continent
  #End Relations
  #Validates
  validates :code,:old_code, presence: true
  validates :code,        length: { in: 2..2 },format: {with:/\A^[^0-9`!@#\$%\^&*+=]+\z/i}
  validates :old_code,    length: { in: 3..3 },format: {with:/\A^[^0-9`!@#\$%\^&*+=]+\z/i}
  #End validates

  has_attached_file :flag, styles: { medium: "312x208>",thumb: "156x104>" }, default_url: "/img/flag-missing.png", path: ":rails_root/public/system/:class/:id/:style.png",url:"/system/:class/:id/:style.png"

  validates_attachment_file_name :flag, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]

  default_scope { order("name_#{I18n.locale}") }
  def to_search
    {
      name:self.name,
      code:self.code,
    }
  end

  def g_map_url
    url = read_attribute(:g_map_url)
    if url.present?
      url = url + "&hl=#{I18n.locale}"
    end
    url
  end

end
