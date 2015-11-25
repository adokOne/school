class EmailTemplate
  include Mongoid::Document

  field :subject, type: String , localize: true
  field :text, type: String , localize: true
  field :active, type: Boolean, default: true
  field :seo_name, type: String
  field :available_tags, type: Array, default: []

  validates_presence_of :subject
  validates_uniqueness_of :seo_name

  scope :active_template, ->(seo_name) { where(seo_name: seo_name, active: true) }


  def id; _id.to_s end


  TAGS = [
    :DOMAIN,
    :USERNAME,
    :EMAIL,
    :PHONE
  ]

end
