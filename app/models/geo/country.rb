class Country < ActiveRecord::Base
  include Localizable
  include Geolizable
  UKRAINE_ID = 396
  #Relations
  has_many :cities, dependent: :restrict_with_exception

  #End Relations
  #Validates

  #End validates


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
