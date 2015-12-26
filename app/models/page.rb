class Page < ActiveRecord::Base
  before_validation :generate_seo
  belongs_to :category
  has_paper_trail on: [:update, :destroy]

  @attachment_sizes =  { home: "760x270#",thumb: "100x100#", big: "800x300#" }

  class << self
     attr_accessor :attachment_sizes
  end

  has_attached_file :logo,
                    styles: Proc.new { |clip| clip.instance.class.attachment_sizes ; clip.instance.class.attachment_sizes; },
                    default_url:  "http://dummyimage.com/800x300/f5f5f5/000000.png&text=#{I18n.t("uex.image_missing")}",#   URI.unescape("https://placeholdit.imgix.net/~text?" + {txtsize: 33, w:800, h:300, text: }.to_query),
                    path:        ":rails_root/public/system/:class/:id/:style.:extension",
                    url:         "/system/:class/:id/:style.:extension"

  validates_attachment :logo,
    content_type: { content_type: /\Aimage/ },
    size: { in: 0.megabytes..10.megabytes }

  delegate :title, to: :category, prefix: true, allow_nil: true
  delegate :seo_name, to: :category, prefix: true, allow_nil: true

  scope :published, -> { }
  scope :by_rating, -> { order('created_at DESC') }
  scope :by_category, ->(id) { where(category_id: id) }
  scope :by_city, ->(id) { where(city_id: id) }

  scope :by_text, ->(id) { where(title: id) }

  belongs_to :user

  has_many :impressions, :as=>:impressionable
  has_many :reviews
  has_many :orders









  #Validates
  validates :title,:country_id, :city_id, :category_id, :user_id, presence: true
  validates :title,     length: { in: 3..200 }
  # validates :anons,     length: { in: 0..5000 }
  validates :active, inclusion:{ in: [true,false] }
  #End validates

  def self.by_text( text )
    if text.present? && text.length > 0
      where("`anons` LIKE :search OR `desc` LIKE :search OR `title` LIKE :search",{search: "%#{text}%"})
    else
      self
    end

  end


  def disactivate!
    self.update_attribute(:active, false)
  end


  def views
    impressions.size
  end

  def reviews_count
    self.reviews.count
  end

  def unique_impression_count
    impressions.group(:ip_address).size #UNTESTED: might not be correct syntax
  end

  def seos
    [self.category.seos].flatten
  end

  def self.find_by_seo seo
    item = Page.where(seo_name: seo.last).first
    return false unless item
    seo.each do |s|
      return false unless item.seos.include?(s)
    end
    item
  end

  def link
    "/#{seos.join('/')}/#{self.id}.html"
  end

  def prepare_breadcrumbs
    self.category.prepare_breadcrumbs
  end

  def generate_seo
    self.seo_name = self.title.russian_translit if self.respond_to?(:seo_name) && !self.title.nil? && self.seo_name.nil?
  end


  def self.get_stat_graph
    sql =
    "SELECT
        DATE(`impressions`.`created_at`) AS `date`,
        impressionable_id,
        SUM(`impressions`.`impressionable_id`) AS `count`

    FROM `impressions`
    WHERE `impressions`.`created_at` BETWEEN '2015-12-01 00:00:00' AND '2015-12-31 23:59:59'
    GROUP BY `date`, `impressionable_id`
    ORDER BY `date`
    "
    ActiveRecord::Base.connection.execute(sql,:as_array).to_a.map do |item|
      {
        date: item.first.strftime("%Y-%m-%d"),
        page_id: item.second,
        count: item.third
      }
    end
  end


  def self.get_stat_graph_unique
    sql =
    "SELECT
        DATE(`impressions`.`created_at`) AS `date`,
        impressionable_id,
        COUNT(DISTINCT ip_address) as count

    FROM `impressions`
    WHERE `impressions`.`created_at` BETWEEN '2015-12-01 00:00:00' AND '2015-12-31 23:59:59'
    GROUP BY `date`, `impressionable_id`
    ORDER BY `date`
    "
    ActiveRecord::Base.connection.execute(sql,:as_array).to_a.map do |item|
      {
        date: item.first.strftime("%Y-%m-%d"),
        page_id: item.second,
        count: item.third
      }
    end
  end

end

