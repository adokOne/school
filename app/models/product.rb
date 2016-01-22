class Product < ActiveRecord::Base

  include Localizable

  validates :name, presence: true
  validates :name,     length: { in: 5..255 }, format: {with:/\A^[^0-9`!@#\$%\^&*+_=]+\z/i}
  validates :active, inclusion:{ in: [true,false] }

  has_attached_file :logo,
                    styles: { medium: "214x210#",thumb: "100x100#" },
                    default_url: "/img/product-logo-missing.png",
                    path:        ":rails_root/public/system/:class/:id/:style.png",
                    url:         "/system/:class/:id/:style.png"

  validates_attachment_file_name :logo, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]


  has_many :orders
  scope :active, -> { where(active: true) }
  scope :for_top, -> { where(show_in_top: true) }
  scope :for_cabinet, -> { where(show_in_cabinet: true) }
  scope :for_table, -> { where(show_on_landing: true) }


  def self.covert_to_uah( amount )
    (amount * self.usd_exchange).to_i
  end

  def link
    "/product/#{self.id}"
  end


  def self.usd_exchange
    setting = Rails.cache.fetch("settings", expires_in: 1.day) do
      Setting.find_by_key("usd_exchange")
    end
    setting ? setting.value.to_s.to_i : 25
  end

  def cost
    if self.has_sale
      self.sale_price
    else
      self.price
    end
  end

end
