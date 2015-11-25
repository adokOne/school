class Airport < ActiveRecord::Base
  include Localizable
  #Relations
  belongs_to :country
  belongs_to :city
  #End Relations
  #Validates
  validates :code,:country_id,:city_id, presence: true
  validates :code,        length: { in: 3..3 },format: {with:/\A^[^0-9`!@#\$%\^&*+=]+\z/i}
  #End validates

  def to_search needed = false
    return nil if !needed && !self.show_on_search || self.code == self.city.code  && !needed
    {
      name:self.name,
      code:self.code,
      country_name:self.country.name,
    }
  end
end
