class EmailTemplate < ActiveRecord::Base
  include Localizable
  validates_presence_of :subject_ru
  validates_uniqueness_of :seo_name

  scope :active_template, ->(seo_name) { where(seo_name: seo_name, active: true) }


  TAGS = [
    :DOMAIN,
    :USERNAME,
    :EMAIL,
    :PHONE
  ]

end
