class Continent < ActiveRecord::Base
  include Localizable
  include Geolizable
  #Relations
  has_many :cities, dependent: :restrict_with_exception
  has_many :countries, dependent: :restrict_with_exception
  #End Relations
  #Validates
  validates :seo_name, presence: true
  #End validates
  default_scope { order("name_#{I18n.locale}") }
end
