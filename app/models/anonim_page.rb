class AnonimPage
  include ::ActiveAttr::Model
  include Paperclip::Glue

  define_model_callbacks :save, only: [:after]
  define_model_callbacks :destroy, only: [:before, :after]
  define_model_callbacks :commit, only: [:after]

  attr_accessor :logo_content_type, :logo_file_name, :logo_file_size

  attribute :name,  type: String
  attribute :email, type: String
  attribute :phone,  type: String

  attribute :country_id,  type: Integer
  attribute :city_id,  type: Integer
  attribute :category_id,  type: Integer
  attribute :title,  type: String
  attribute :anons,  type: String
  attribute :desc,  type: String



  validates :email, :name, :email, :category_id, :country_id, :city_id, :title, :presence => true
  validates :email,    length: { in: 6..50 }, format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :name, length: { in: 3..100 }
  validates :phone, length: { in: 5..20 }
  validates :title, length: { in: 5..255 }
  validates :desc, length: { in: 0..255000 }
  validates :anons, length: { in: 0..25500 }

  has_attached_file :logo,
                    styles: { home: "760x270#",thumb: "100x100#", big: "800x300#" },
                    default_url:  "http://dummyimage.com/800x300/f5f5f5/000000.png&text=#{I18n.t("uex.image_missing_add")}",
                    path:        ":rails_root/public/system/:class/:id/:style.:extension",
                    url:         "/system/:class/:id/:style.:extension"


  validates_attachment :logo,
    content_type: { content_type: /\Aimage/ },
    size: { in: 0.megabytes..1.megabytes }

  def user_exist?
    !User.where(email: self.email ).count.zero?
  end

  def create_real(logo)
    user = User.find_by_email(self.email)
    data = {
      country_id: self.country_id,
      city_id: self.city_id,
      category_id: self.category_id,
      title: self.title,
      anons: self.anons,
      desc: self.desc,
      logo: logo,
      user_id: user.id,
      phone: user.phone,
      email: user.email
    }
    page = user.pages.create(data)
  end



end
